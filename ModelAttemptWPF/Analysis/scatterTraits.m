clear;
close all

script_path = fileparts(mfilename('fullpath'));
cd (script_path);

nFake=100;
nTrue=200;
nRuns=1;
population=1000;
OL=zeros(nRuns,population);
varParamVals = {'OL40_', 'OL60_'};
fakeShares=zeros(nRuns,population);
nFollowers=zeros(nRuns,population);

varParamVals_len = size(varParamVals);
varParamVals_len = varParamVals_len(2);
resultsPaths = cell(nRuns, varParamVals_len);

for i = 1:nRuns
    for j = 1:varParamVals_len
        tempPath = fullfile(...
        '..','Results', {['OL40_' int2str(i)], ...
        ['OL60_' int2str(i)]});
        resultsPaths{i, j} = fullfile(tempPath{j}, 'nSharesPopulation.csv');
    end
end

for fileIndex = 1:varParamVals_len
    clearvars -except fileIndex resultsPaths varParamVals_len varParamVals nFollowers fakeShares OL population nRuns nTrue nFake
    for i=1:nRuns
        fileName = resultsPaths{i, fileIndex};
        disp(fileName)
        runParam = [varParamVals{fileIndex} int2str(i)];
        disp(runParam)
        nSharesPop=csvread(fileName,1,1);
        nFollowers(i,:)=nSharesPop(:,1);
        o(i,:)=nSharesPop(:,2);
        c(i,:)=nSharesPop(:,3);
        e(i,:)=nSharesPop(:,4);
        a(i,:)=nSharesPop(:,5);
        n(i,:)=nSharesPop(:,6);
        OL(i,:)=nSharesPop(:,7);
        trueShares(i,:)=nSharesPop(:,8);
        fakeShares(i,:)=nSharesPop(:,9);
        ratio(i,:)=nSharesPop(:,10);
        freqUse(i,:)=nSharesPop(:,11);
        sessionLength(i,:)=20.*(nSharesPop(:,12));
        shareFreq(i,:)=nSharesPop(:,13);
    end
    nFollowers_all=reshape(nFollowers,[1,nRuns*population]);
    o_all=reshape(o,[1,nRuns*population]);
    c_all=reshape(c,[1,nRuns*population]);
    e_all=reshape(e,[1,nRuns*population]);
    a_all=reshape(a,[1,nRuns*population]);
    n_all=reshape(n,[1,nRuns*population]);
    OL_all=reshape(OL,[1,nRuns.*population]);
    trueShares_all=reshape(trueShares,[1,nRuns*population]);
    fakeShares_all=reshape(fakeShares,[1,nRuns*population]);
    ratio_all=reshape(ratio,[1,nRuns*population]);
    freqUse_all=reshape(freqUse,[1,nRuns*population]);
    sessionLength_all=reshape(sessionLength,[1,nRuns*population]);
    % // TODO 
    % ? Should this be a ceiling function
    roundSL_all=ceil(sessionLength_all);
    shareFreq_all=reshape(shareFreq,[1,nRuns*population]);
    % sort them all
    %[OL_all,indices]=sort(OL_all);
    %fakeShares_all=fakeShares_all(indices);
    %ratio_all=ratio_all(indices);
    %trueShares_all=trueShares_all(indices);
    %nFollowers_all=nFollowers_all(indices);
    %e_all=e_all(indices);
    %%
    scatter(sessionLength_all,fakeShares_all./trueShares_all,8,'filled') %,'MarkerFaceAlpha',0.05)
    % // TODO (above)
    % MATLAB <-> Octave compatibility (above)
    saveName = [runParam  '_test2.png'];
    saveas(gcf, saveName);
    xlabel('Session Length')
    ylabel('Ratio of fake to true news shared')
    %%
    scatter(nFollowers_all,fakeShares_all./trueShares_all,4)
    xlabel('Number of connections')
    ylabel('Ratio of fake to true news shared')
    %%
    scatter(nFollowers_all,fakeShares_all,4)
    xlabel('Number of connections')
    ylabel('Number of shares of fake news')

    %%
    histogram(nFollowers_all,50,'Normalization','pdf')
    ylabel('Probability density')
    xlabel('Number of connections')
    %%
    % close all
    nBins=50;
    figure()
    histogram(e_all,nBins,'Normalization','pdf');
    eLine=normpdf(sort(e_all),0.648,0.164);
    hold on
    %plot(sort(e_all),eLine,'k-','LineWidth',2)
    hold off

    figure()
    histogram(o_all,nBins,'Normalization','pdf');
    oLine=normpdf(sort(o_all),0.734,0.128);
    hold on
    %plot(sort(o_all),oLine,'k-','LineWidth',2)
    hold off

    figure()
    histogram(c_all,nBins,'Normalization','pdf');
    cLine=normpdf(sort(c_all),0.73,0.14);
    hold on
    %plot(sort(c_all),cLine,'k-','LineWidth',2)
    hold off

    figure()
    histogram(a_all,nBins,'Normalization','pdf');
    aLine=normpdf(sort(a_all),0.748,0.124);
    hold on
    %plot(sort(a_all),aLine,'k-','LineWidth',2)
    hold off

    figure()
    histogram(n_all,nBins,'Normalization','pdf');
    nLine=normpdf(sort(n_all),0.594,0.16);
    hold on
    %plot(sort(n_all),nLine,'k-','LineWidth',2)
    hold off
    %%
    plotScatter(o_all,ratio_all,'Openness','Ratio of fake to true shares')
    plotScatter(c_all,ratio_all,'Conscientiousness','Ratio of fake to true shares')
    plotScatter(e_all,ratio_all,'Extroversion','Ratio of fake to true shares')
    plotScatter(a_all,ratio_all,'Agreeableness','Ratio of fake to true shares')
    plotScatter(n_all,ratio_all,'Neuroticism','Ratio of fake to true shares')
    %%
    % close all
    plotScatter(c_all,freqUse_all,'Conscientiousness','Frequeny of use')
    plotScatter(e_all,freqUse_all,'Extroversion','Frequency of use')
    plotScatter(a_all,freqUse_all,'Agreeableness','Frequency of use')
    plotScatter(n_all,freqUse_all,'Neuroticism','Frequency of use')
    %%
    % close all
    plotScatter(c_all,sessionLength_all,'Conscientiousness','Frequeny of use')
    plotScatter(e_all,freqUse_all,'Extroversion','Frequency of use')
    plotScatter(a_all,freqUse_all,'Agreeableness','Frequency of use')
    plotScatter(n_all,freqUse_all,'Neuroticism','Frequency of use')
    %%
    % close all
    plotScatter(c_all,fakeShares_all,'Conscientiousness','Number of fake shares')
    % // TODO
    % ? hold on
    plotScatter(e_all,fakeShares_all,'Extroversion','Number of fake shares')
    % // TODO
    % ? off
    plotScatter(a_all,fakeShares_all,'Agreeableness','Number of fake shares')
    plotScatter(n_all,fakeShares_all,'Neuroticism','Number of fake shares')
    %%
    % close all
    plotScatter(c_all,sessionLength_all,'Conscientiousness','Session length (number of news posts)')

    plotScatter(e_all,sessionLength_all,'Extroversion','Session length (number of news posts)')
    plotScatter(n_all,sessionLength_all,'Neuroticism','Session length (number of news posts)')
    %%
    % close all
    plotScatter(freqUse_all,fakeShares_all,'Frequency of use','Number of fake shares')

    figure()
    scatter(freqUse_all,ratio_all);
    hold off
    %histogram(sessionLength_all,'Normalization','probability','BinWidth',1)
    %xlabel('Session length (number of news posts)')
    %ylabel('Probability')
    %%
    % close all
    [e_all, indices]=sort(e_all);
    ratio_all=ratio_all(indices);
    fakeShares_all=fakeShares_all(indices);
    figure()
    scatter(e_all,fakeShares_all,4)
    xlabel('Extroversion')
    ylabel('Number of shares of fake news')
    %%
    % close all
    plotScatter(sessionLength_all,fakeShares_all,'Session length (number of news posts)','Number of fake shares');
    plotScatter(sessionLength_all,ratio_all,'Session length (number of news posts)','Ratio of fake to true news');
    plotScatter(shareFreq_all,ratio_all,'Share frequency','Number of fake shares')
    %%
    % close all
    plotScatter(c_all,sessionLength_all,'Conscientiousness','Session length (number of news posts)')
    hold on
    cFit= -6.021.*c_all+10.12;
    cUpper=-5.959.*c_all+10.16;
    cLower=-6.084.*c_all+10.07;
    cRMSE=0.9361;
    %plot(c_all,cFit,'w-','LineWidth',2)
    %plot(c_all,cFit+cRMSE,'y--','LineWidth',2)
    %plot(c_all,cFit-cRMSE,'y--','LineWidth',2)
    hold off
    %      f(x) = p1*x + p2
    % Coefficients (with 95% confidence bounds):
    %        p1 =      -6.021  (-6.084, -5.959)
    %        p2 =       10.12  (10.07, 10.16)
    plotScatter(e_all,sessionLength_all,'Extroversion','Session length (number of news posts)')
    hold on
    eFit=5.067.*e_all+2.535;
    eUpper=5.118.*e_all+2.57;
    eLower=5.015.*e_all+2.501;
    eRMSE=0.9273;
    %plot(e_all,eFit,'w-','LineWidth',2)
    %plot(e_all,eFit-eRMSE,'y--','LineWidth',2)
    %plot(e_all,eFit+eRMSE,'y--','LineWidth',2)
    hold off
    %      f(x) = p1*x + p2
    % Coefficients (with 95% confidence bounds):
    %        p1 =       5.067  (5.015, 5.118)
    %        p2 =       2.535  (2.501, 2.57)
    plotScatter(n_all,sessionLength_all,'Neuroticism','Session length (number of news posts)')
    hold on
    nFit=3.032.*n_all+3.983;
    nUpper=3.095.*n_all+4.021;
    nLower=2.97.*n_all+3.945;
    nRMSE=1.125;
    %plot(n_all,nFit,'w-','LineWidth',2)
    %plot(n_all,nFit+nRMSE,'y--','LineWidth',2)
    %plot(n_all,nFit-nRMSE,'y--','LineWidth',2)
    hold off
    %    f(x) = p1*x + p2
    % Coefficients (with 95% confidence bounds):
    %        p1 =       3.032  (2.97, 3.095)
    %        p2 =       3.983  (3.945, 4.021)

    %%
    % close all
    plotScatter(o_all,fakeShares_all,'o','n fake shares')
    plotScatter(c_all,fakeShares_all,'c','n fake shares')
    plotScatter(n_all,ratio_all,'n','ratio')
    plotScatter(a_all,fakeShares_all,'a','n fake shares')
    plotScatter(e_all,fakeShares_all,'e','number of fake shares')

    %%
    %heatmap
    % close all
    figure()
    scatter(e_all,OL_all,10,fakeShares_all.^0.5,'filled');
    xlabel('Extroversion')
    ylabel('Online literacy')

    figure()
    scatter(n_all,fakeShares_all)

    %%
    %heatmap
    % close all
    figure()
    scatter(e_all,n_all,10,fakeShares_all,'filled');
    xlabel('Extroversion')
    ylabel('Conscientiousness')

    %%
    % close all
    [e_all, indices]=sort(e_all);
    nFollowers_all=nFollowers_all(indices);
    scatter(e_all,nFollowers_all,4)
    xlabel('Extroversion')
    ylabel('Number of connections')
    %%
    figure(2)
    scatter(OL_all,ratio_all,4);
    hold on
    xlabel('Online literacy');
    ylabel('Ratio of fake to true shares')
    fit=4.43./(81.78.*OL_all +16.12) +0.1216;
    [OL_all2,ind]=sort(OL_all);
    %plot(OL_all2,fit(ind),'k-')
    %plot(OL_all2,fit(ind).*2,'k--')
    hold off
    saveName = [runParam  '_thing.png'];
    saveas(gcf, saveName)
    legend('Data','fit to y= d +(a/(bx +c))','Probability ratio')
    %     f(x) = a./(b.*x +c) +d
    % Coefficients (with 95% confidence bounds):
    %        a =        4.43  (-7.041e+05, 7.041e+05)
    %        b =       81.78  (-1.3e+07, 1.3e+07)
    %        c =       16.12  (-2.562e+06, 2.562e+06)
    %        d =      0.1216  (0.119, 0.1241)
    %%
    figure(3)
    [OL_all2,ind]=sort(OL_all);
    fs2=fakeShares_all(ind);
    scatter(OL_all2,fakeShares_all(ind),4);
    hold on
    % 
    %      f(x) = p1*x^6 + p2*x^5 + p3*x^4 + p4*x^3 + p5*x^2 + 
    %                     p6*x + p7
    % Coefficients (with 95% confidence bounds):
    %        p1 =       -1611  (-2014, -1207)
    %        p2 =        5313  (4100, 6527)
    %        p3 =       -6776  (-8171, -5381)
    %        p4 =        4094  (3328, 4859)
    %        p5 =       -1047  (-1251, -843.7)
    %        p6 =      -39.71  (-63, -16.41)
    %        p7 =       81.33  (80.49, 82.17)


    fit100=-1611*OL_all2.^6 + 5313*OL_all2.^5 + -6776*OL_all2.^4 + 4094*OL_all2.^3 + -1047*OL_all2.^2 + -39.71*OL_all2 + 81.33;
    %% garble(OL_all2,fit100,'w-','LineWidth',2);

    %upper100=37.74./(OL_all+0.4454)-12.96;
    %lower100=34.36./(OL_all+0.412)-15.12;
    %% garble(OL_all,upper100,'y--','LineWidth',2)
    %% garble(OL_all,lower100,'y--','LineWidth',2)
    hold off
    legend('Data','fit')
    xlabel('Online literacy')
    ylabel('Number of fake news shares')
    %         f(x) = a./(x+b) +c
    %Coefficients (with 95% confidence bounds):
    %       a =       36.05  (34.36, 37.74)
    %       b =      0.4287  (0.412, 0.4454)
    %       c =      -14.04  (-15.12, -12.96)
end
%%
function []=plotScatter(x,y,xtitle,ytitle)
    %  [x, indices]=sort(x);
    %   y=y(indices);
    figure()
    scatter(x,y,3)
    xlabel(xtitle)
    ylabel(ytitle)
end