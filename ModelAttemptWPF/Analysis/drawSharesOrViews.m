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
      tc = sum(matb > 720,2)./n;
      taF = sum(mataF,2)./nF;
      tbF = sum(matbF,2)./nF;
      tcF = sum(matbF > 720,2)./nF;
      taT = sum(mataT,2)./nT;
      tbT = sum(matbT,2)./nT;
      tcT = sum(matbT > 720,2)./nT;
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
      title("Total shares")
      hold on;
      plot(X,'color',[c,1-c,0.2]);
      figure(figAT);
      title("Total true shares")
      hold on;
      plot(XT,'color',[c,1-c,0.2]);
      figure(figAF);
      title("Total fake shares")
      hold on;
      plot(XF,'color',[c,1-c,0.2]);
      figure(figBAll);
      title("Total views")
      hold on;
      plot(Y,'color',[c,1-c,0.2]);
      figure(figBT);
      title("Total true views")
      hold on;
      plot(YT,'color',[c,1-c,0.2]);
      figure(figBF);
      title("Total fake views")
      hold on;
      plot(YF,'color',[c,1-c,0.2]);
      figure(figCAll);
      title("Total viral")
      hold on;
      plot(Z,'color',[c,1-c,0.2]);
      figure(figCT);
      title("Total true viral")
      hold on;
      plot(ZT,'color',[c,1-c,0.2]);
      figure(figCF);
      title("Total fake viral")
      hold on;
      plot(ZF,'color',[c,1-c,0.2]);
  end
  hold off;
end