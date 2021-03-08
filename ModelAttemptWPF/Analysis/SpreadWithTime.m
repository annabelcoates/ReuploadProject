clear;
script_path = fileparts(mfilename('fullpath'));
cd (script_path);

nFake=100;
nTrue=200;
nRuns=50;
runTime=300;
fakeShares=zeros(nRuns,runTime);
fakeViews= zeros(nRuns,runTime);
trueShares=zeros(nRuns,runTime);
trueViews=zeros(nRuns,runTime);
fileExtensions={'OL40_1','OL60_1'};
values=[40,60];

for a=1:length(values)
    filename=fileExtensions{a};
    for i=1:nRuns
        % TODO
        % ! Hardcoded values
        sFilename=['..\Results\' filename '\nSharesAll.csv'];
        vFilename=['..\Results\' filename '\nViewsAll.csv'];
        sharesData=csvread(sFilename);
        viewsData=csvread(vFilename);
        fakeShares(i,:)=mean(sharesData(1:nFake,1:runTime));
        fakeViews(i,:)= mean(viewsData(1:nFake,1:runTime));
        trueShares(i,:)=mean(sharesData(nFake+1:(nTrue+nFake),1:runTime));
        trueViews(i,:)=mean(viewsData(nFake+1:(nTrue+nFake),1:runTime));
    end
    meanFakeSpread=mean(fakeShares);
    sFakeSpread(a,:)=meanFakeSpread;
    sTrueSpread(a,:)=mean(trueShares);
    vFakeSpread(a,:)=mean(fakeViews);
    vTrueSpread(a,:)=mean(trueViews);
end

% %% Can't remember what this is doing
% fNotFound=1;
% tNotFound=1;
% for i=1:runTime
%     if (fNotFound) & (sFakeSpread(i)>= max(sFakeSpread)*0.90)
%         fakePT=i;
%         fNotFound=0;
%     end
%     if (tNotFound) & (sTrueSpread(i) >= max(sTrueSpread)*0.99)
%         truePT=i;
%         tNotFound=0;
%     end
% end
% %%
% for a=1:length(values)
%     figure()
%     plot(sFakeSpread(a,:),'LineWidth',2)
%     hold on
%     plot(sTrueSpread(a,:),'LineWidth',2)
%     plot(fakePT(a),sFakeSpread(a,fakePT(a)),'o','MarkerSize',10)
%     plot(truePT(a),sTrueSpread(a,truePT(a)),'o','MarkerSize',10)
% 
%     xlabel('Time')
%     ylabel('Number of accounts')
%     xticks([])
% end

%%
close all
for a=1:length(values)
    %  find the plateau time
    gradFake=gradient(sFakeSpread(a,:),1);
    gradTrue=gradient(sTrueSpread(a,:),1);
    
    % create a floating point average
    radius=20;
    for k=1:runTime
        startVal=max(1,k-radius);
        endVal=min(runTime,k+radius);
        fakeGradFloat(k)=mean(gradFake(startVal:endVal));
        trueGradFloat(k)=mean(gradTrue(startVal:endVal));
    end
    
    
    maxGradFake=max(fakeGradFloat);
    maxGradTrue=max(trueGradFloat);
    
    
    fNotFound=1;
    tNotFound=1;
    
    for i=1:runTime
        % // TODO
        % Never goes to truePT case
        if (fNotFound) & (fakeGradFloat(i)-min(fakeGradFloat)<=0.05*maxGradFake)
            fakePT(a)=i;
            fNotFound=0;
        end
        if (tNotFound) & (trueGradFloat(i)-min(fakeGradFloat)<=0.05*maxGradTrue)
            disp('True Case')
            truePT(a)=i;
            tNotFound=0;
        end
    end
    fNotFound=1;
    tNotFound=1;
    
%     figure(a)
% 
%     plot(fakeGradFloat)
%     hold on
%     plot(fakePT(a),fakeGradFloat(fakePT(a)),'o','MarkerSize',10)
%     plot(trueGradFloat)
%     plot(truePT(a),trueGradFloat(truePT(a)),'o','MarkerSize',10)
%     ylabel('gradient')
%     hold off
    
    
    figure(a)

    plot(sFakeSpread(a,:),'LineWidth',2)
    hold on
    plot(fakePT(a),sFakeSpread(a,fakePT(a)),'o','MarkerSize',10)
    plot(sTrueSpread(a,:),'LineWidth',2)
    plot(truePT(a),sTrueSpread(a,truePT(a)),'o','MarkerSize',10)
    ylabel('Number of shares')
    xlabel('Time')
    xticks([])
    hold off
end

%% // TODO
figure()
ratio=(truePT./fakePT);
plot(values,ratio,'x','MarkerSize',10)
ylabel('Ratio of fake plateau time to true plateau time')