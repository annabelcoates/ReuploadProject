function drawSharesVsViews(s,v,nF,nT)
  n = nT + nF;
  hold off;
  inputs = fieldnames(s);
  %should be the same for both
  for i = 1:numel(inputs)
      mata = s.(inputs{i});
      matb = v.(inputs{i});
      mataF = mata(1,1:nF,:);
      mataT = mata(1,nF+1:n,:);
      matbF = matb(1,1:nF,:);
      matbT = matb(1,nF+1:n,:);
      ta = sum(mata,2)./n;
      tb = sum(matb,2)./n;
      taF = sum(mataF,2)./nF;
      tbF = sum(matbF,2)./nF;
      taT = sum(mataT,2)./nT;
      tbT = sum(matbT,2)./nT;
      X = squeeze(ta);
      Y = squeeze(tb);
      XF = squeeze(taF);
      YF = squeeze(tbF);
      XT = squeeze(taT);
      YT = squeeze(tbT);
      plot(YT);
      hold on;
      plot(YF);
      %plot(X);
  end
  hold off;
end