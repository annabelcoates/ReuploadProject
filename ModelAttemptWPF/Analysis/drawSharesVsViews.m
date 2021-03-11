function drawSharesVsViews(s,v,nF,nT)
  n = nT + nF;
  hold on;
  inputs = fieldnames(s);
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
  for i = 1:numel(inputs)
      [runs, ~] = size(s.(inputs{i}));
      runs
      mata = sum(s.(inputs{i}),1)./runs;
      matb = sum(v.(inputs{i}),1)./runs;
      mataF = mata(1,1:nF,:);
      mataT = mata(1,nF+1:n,:);
      matbF = matb(1,1:nF,:);
      matbT = matb(1,nF+1:n,:);
      ta = sum(mata,2)./n;
      tb = sum(matb,2)./n;
      tc = sum(matb > 750,2)./n;
      taF = sum(mataF,2)./nF;
      tbF = sum(matbF,2)./nF;
      tcF = sum(matbF > 750,2)./nF;
      taT = sum(mataT,2)./nT;
      tbT = sum(matbT,2)./nT;
      tcT = sum(matbT > 750,2)./nT;
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
      plot(X);
      figure(figAT);
      title("Total true shares")
      hold on;
      plot(XT);
      figure(figAF);
      title("Total fake shares")
      hold on;
      plot(XF);
      figure(figBAll);
      title("Total views")
      hold on;
      plot(Y);
      figure(figBT);
      title("Total true views")
      hold on;
      plot(YT);
      figure(figBF);
      title("Total fake views")
      hold on;
      plot(YF);
      figure(figCAll);
      title("Total viral")
      hold on;
      plot(Z);
      figure(figCT);
      title("Total true viral")
      hold on;
      plot(ZT);
      figure(figCF);
      title("Total fake viral")
      hold on;
      plot(ZF);
  end
  hold off;
end