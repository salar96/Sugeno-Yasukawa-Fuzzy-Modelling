function [ err ] = costfnHY(B,Xin,Y,fis,clus_num)

% this is the cost function for higher rounds
% B is a 5*2^round vector
s=size(Xin);
nvars=s(2);

for i=1:clus_num
    % i represents rule number
   b=i*(nvars+1);
   a=b-(nvars);
fis.output.mf(i).params=B(a:b);
end

err=sqrt(sum((evalfis(Xin,fis)-Y).^2));

end



