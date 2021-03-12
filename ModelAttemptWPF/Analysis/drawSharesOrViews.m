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
      %c = (i-1)/(s.extra.varParamVals_len-1);
      if (i == 1)
          shape = '';
          c = '#909090';
      else
          shape = '--';
          c = 'black';
      end
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
      %title("Sharing any news")
      xlabel("Time steps");
      ylabel("Shares per news article");
      ylim([0 100]);
      hold on;
      plot(X, shape, 'Linewidth', 1.5, 'color',c);
      figure(figAT);
      %title("Sharing true news")
      xlabel("Time steps");
      ylabel("Shares per true news article");
      ylim([0 100]);
      hold on;
      plot(XT, shape, 'Linewidth', 1.5, 'color',c);
      figure(figAF);
      %title("Sharing fake news")
      xlabel("Time steps");
      ylabel("Shares per fake news article");
      ylim([0 100]);
      hold on;
      plot(XF, shape, 'Linewidth', 1.5, 'color',c);
      figure(figBAll);
      %title("Viewing any news")
      xlabel("Time steps");
      ylabel("Views per news article");
      ylim([0 750]);
      hold on;
      plot(Y, shape, 'Linewidth', 1.5, 'color',c);
      figure(figBT);
      %title("Viewing true news")
      xlabel("Time steps");
      ylabel("Views per true news article");
      ylim([0 750]);
      hold on;
      plot(YT, shape, 'Linewidth', 1.5, 'color',c);
      figure(figBF);
      %title("Viewing fake news")
      xlabel("Time steps");
      ylabel("Views per fake news article");
      ylim([0 750]);
      hold on;
      plot(YF, shape, 'Linewidth', 1.5, 'color',c);
      figure(figCAll);
      %title("News going viral")
      xlabel("Time steps");
      ylabel("Proportion news gone viral");
      ylim([0 1]);
      hold on;
      plot(Z, shape, 'Linewidth', 1.5, 'color',c);
      figure(figCT);
      %title("True news going viral")
      xlabel("Time steps");
      ylabel("Proportion true news gone viral");
      ylim([0 1]);
      hold on;
      plot(ZT, shape, 'Linewidth', 1.5, 'color',c);
      figure(figCF);
      %title("Fake news going viral")
      xlabel("Time steps");
      ylabel("Proportion fake news gone viral");
      ylim([0 1]);
      hold on;
      plot(ZF, shape, 'Linewidth', 1.5, 'color',c);
  end
  hold off;
  set(figAAll, 'Position', [100,100,250,250]);
  saveas(figAAll, 'SN.png');
  set(figAT, 'Position', [100,100,250,250]);
  saveas(figAT, 'STN.png');
  set(figAF, 'Position', [100,100,250,250]);
  saveas(figAF, 'SFN.png');
  set(figBAll, 'Position', [100,100,250,250]);
  saveas(figBAll, 'VN.png');
  set(figBT, 'Position', [100,100,250,250]);
  saveas(figBT, 'VTN.png');
  set(figBF, 'Position', [100,100,250,250]);
  saveas(figBF, 'VFN.png');
  set(figCAll, 'Position', [100,100,250,250]);
  saveas(figCAll, 'RN.png');
  set(figCT, 'Position', [100,100,250,250]);
  saveas(figCT, 'RTN.png');
  set(figCF, 'Position', [100,100,250,250]);
  saveas(figCF, 'RFN.png');
end