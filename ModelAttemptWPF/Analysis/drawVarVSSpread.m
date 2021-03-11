function drawVarVsSpread(s,v,nF,nT)
  n = nT + nF;
  inputs = fieldnames(s);
  %should be the same for both
  for i = 1:numel(inputs)
    matS = s.(inputs{i});
    matV = v.(inputs{i});
    totS(i) = sum(matS(:,:,300),'all')./n;
    totSF(i) = sum(matS(:,1:nF,300),'all')./nF;
    totST(i) = sum(matS(:,nF+1:n,300),'all')./nT;
    totV(i) = sum(matV(:,:,300),'all')./n;
    totVF(i) = sum(matV(:,1:nF,300),'all')./nF;
    totVT(i) = sum(matV(:,nF+1:n,300),'all')./nT;
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
  plot(X,totVT);
  hold off;
end