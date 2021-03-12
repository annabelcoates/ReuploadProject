function drawSharesOrViews(s,v,nF,nT)
  n = nT + nF;
  hold on;
  inputs = s.extra.varParamVals;
  %should be the same for both
  figAAll = figure();
  figAT = figure();
  figAF = figure();
  figBAll = figure();
  figBT = figure();
  figBF = figure();
  figCAll = figure();
  figCT = figure();
  figCF = figure();
  for i = 1:s.extra.varParamVals_len
      c = (i-1)/(s.extra.varParamVals_len-1);
      % Get the number of runs
      [runs, ~] = size(s.(inputs{i}));
      mata = sum(s.(inputs{i}),1)./runs;
      matb = sum(v.(inputs{i}),1)./runs;
      mataF = mata(1,1:nF,:);
      mataT = mata(1,nF+1:n,:);
      matbF = matb(1,1:nF,:);
      matbT = matb(1,nF+1:n,:);
      ta = sum(mata,2)./n;
      tb = sum(matb,2)./n;
      tc = sum(matb > 667,2)./n;
      taF = sum(mataF,2)./nF;
      tbF = sum(matbF,2)./nF;
      tcF = sum(matbF > 667,2)./nF;
      taT = sum(mataT,2)./nT;
      tbT = sum(matbT,2)./nT;
      tcT = sum(matbT > 667,2)./nT;
      X = squeeze(ta);
      Y = squeeze(tb);
      Z = squeeze(tc);
      XF = squeeze(taF);
      YF = squeeze(tbF);
      ZF = squeeze(tcF);
      XT = squeeze(taT);
      YT = squeeze(tbT);
      ZT = squeeze(tcT);
      figure(figAAll);
      title("Sharing any news")
      xlabel("Time steps");
      ylabel("Shares per news article");
      ylim([0 100]);
      hold on;
      plot(X,'color',[c,1-c,0.2]);
      figure(figAT);
      title("Sharing true news")
      xlabel("Time steps");
      ylabel("Shares per true news article");
      ylim([0 100]);
      hold on;
      plot(XT,'color',[c,1-c,0.2]);
      figure(figAF);
      title("Sharing fake news")
      xlabel("Time steps");
      ylabel("Shares per fake news article");
      ylim([0 100]);
      hold on;
      plot(XF,'color',[c,1-c,0.2]);
      figure(figBAll);
      title("Viewing any news")
      xlabel("Time steps");
      ylabel("Views per news article");
      ylim([0 750]);
      hold on;
      plot(Y,'color',[c,1-c,0.2]);
      figure(figBT);
      title("Viewing true news")
      xlabel("Time steps");
      ylabel("Views per true news article");
      ylim([0 750]);
      hold on;
      plot(YT,'color',[c,1-c,0.2]);
      figure(figBF);
      title("Viewing fake news")
      xlabel("Time steps");
      ylabel("Views per fake news article");
      ylim([0 750]);
      hold on;
      plot(YF,'color',[c,1-c,0.2]);
      figure(figCAll);
      title("News going viral")
      xlabel("Time steps");
      ylabel("Proportion news gone viral");
      ylim([0 1]);
      hold on;
      plot(Z,'color',[c,1-c,0.2]);
      figure(figCT);
      title("True news going viral")
      xlabel("Time steps");
      ylabel("Proportion true news gone viral");
      ylim([0 1]);
      hold on;
      plot(ZT,'color',[c,1-c,0.2]);
      figure(figCF);
      title("Fake news going viral")
      xlabel("Time steps");
      ylabel("Proportion fake news gone viral");
      ylim([0 1]);
      hold on;
      plot(ZF,'color',[c,1-c,0.2]);
  end
  hold off;
  saveas(figAAll, 'SN.png');
  saveas(figAT, 'STN.png');
  saveas(figAF, 'SFN.png');
  saveas(figBAll, 'VN.png');
  saveas(figBT, 'VTN.png');
  saveas(figBF, 'VFN.png');
  saveas(figCAll, 'RN.png');
  saveas(figCT, 'RTN.png');
  saveas(figCF, 'RFN.png');
end