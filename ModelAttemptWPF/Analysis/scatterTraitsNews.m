close all

script_path = fileparts(mfilename('fullpath'));
cd (script_path)

nFake=100;
nTrue=200;
nRuns=50;
population=1000;
nNews=300;
OL=zeros(nRuns,population);
fakeShares=zeros(nRuns,population);
nFollowers=zeros(nRuns,population);

for i=1:nRuns
    newsInfo=csvread('..\Results\OL40_'+int2str (i)+"\newsInfo.csv");
    newsB(i,:)=newsInfo(:,1);
    newsE(i,:)= newsInfo(:,2);
    nSharesAll=csvread('..\Results\OL40_'+int2str (i)+"\nSharesAll.csv");
    nShares(i,:)=nSharesAll(:,1000);
    
end
newsB_all=reshape(newsB,[1,nNews.*nRuns]);
newsE_all=reshape(newsE,[1,nNews.*nRuns]);
nShares_all=reshape(nShares,[1,nNews.*nRuns]);

%%
close all
plotScatter(newsB_all,nShares_all,'Believability','Number of shares')
figure()
scatter(newsE_all,nShares_all,4)
%'Emotional level','Number of shares')
%%
scatter(newsB_all,nShares_all,4,newsE_all,'o','filled')
colorbar()
xlabel('Believability')
ylabel('Number of shares')
%%
scatter(newsB_all,nShares_all,4,newsE_all)
colorbar()
xlabel('Believability')
ylabel('Number of shares')
%%
function []=plotScatter(x,y,xtitle,ytitle)
  %  [x, indices]=sort(x);
  %   y=y(indices);
    figure()
    scatter(x,y,5,'o','filled','MarkerFaceAlpha',0.2)
    xlabel(xtitle)
    ylabel(ytitle)
end
