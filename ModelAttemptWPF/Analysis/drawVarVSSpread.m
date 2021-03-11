function drawVarVsSpread(s,v,nF,nT)
  n = nT + nF;
  inputs = fieldnames(s);
  %should be the same for both
  for i = 1:s.extra.varParamVals_len
    [runs, ~] = size(s.(inputs{i}));
    matS = s.(inputs{i});
    matV = v.(inputs{i});
    totS(i) = sum(matS(:,:,300),'all')./n./runs;
    totSF(i) = sum(matS(:,1:nF,300),'all')./nF./runs;
    totST(i) = sum(matS(:,nF+1:n,300),'all')./nT./runs;
    totV(i) = sum(matV(:,:,300),'all')./n./runs;
    totVF(i) = sum(matV(:,1:nF,300),'all')./nF./runs;
    totVT(i) = sum(matV(:,nF+1:n,300),'all')./nT./runs;
  end
  X = 0:0.1:1;
  figure();
  hold on;
  plot(X,totS,'--');
  plot(X,totSF,'-.');
  plot(X,totST);
  hold off;
  figure();
  hold on;
  plot(X,totV,'--');
  plot(X,totVF,'-.');
  plot(X,totST);
  hold off;
end