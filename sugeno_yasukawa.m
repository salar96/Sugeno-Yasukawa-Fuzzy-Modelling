%% INTRODUCTION
% _*SALAR BASIRI 
% 97200346
% FUZZY SETS THEORY: D.R. BAGHERI SHOURAKI
% %SUGENO-YASUKAWA ALGORITHEM
% DECEMBER 20th, 2018
% ANY COPY OF THE SCRIPT WITHOUT THE PERMISSION OF THE WRITER IS NOT
% ALLOWED.
% CONTACT: salarbsr.1996@gmail.com
% basiri.salar@mech.sharif.ir*_
%Sharif University of Technology
clear;close all;clc
%% 1: Defining process main variables
clus_num=2;
% number of output clusters
% set 2 for default
f_rate=3;
% rate of fuzziness of clusters. lower numbers means lower overlap.
vari_num=4;
%number of variables
level=3;
% how many levels should we proceed
repeat=1;
% number of repeats in every optimization.
% 1 is good most of the times (unless data is really nonlinear)
% set 2 for more accurate but slower answers
fis=cell(1,vari_num);
% each part of the fis shows a fuzzy inference system that has been bult by
% n-th variable
minval=zeros(1,vari_num);
%% 2: Data gathering
% X1=randi([-1000 1000],2000,1)/100;rng;
% X2=randi([-1000 1000],2000,1)/100;rng;
[x1,x2] = meshgrid(-10:0.33:10,-10:0.33:10); 
% two main inputs
X3=randi([80 101],3721,1)/10;rng;
% this is a noise data
X4=randi([-100 -8],3721,1)/10;
% this is a noise data
%%%
y1=sin(x1)./x1.*sin(x2)./x2;
% Y=X1.^2-X2.^2;
X1 = [];    X2 = [];  Y = [];
for i=1:size(x1,1)
    X1 = [X1 x1(i,:)];
    X2 = [X2 x2(i,:)];
    Y = [Y y1(i,:)];
end
X1=X1';
X2=X2';
Y=Y';
X=[X1,X2,X3,X4,Y];
%% 3: Optimization process

for round=1:level
    


  if round==1
    
disp('----------ROUND 1 Begins---------')
disp('---------------------------------------')
disp('---------------------------------------')

for n=1:vari_num
opt=[f_rate,1e6,0.001,0];
fis{n}=genfis3(X(:,n),Y,'sugeno',clus_num,opt);

fval_min=1e10;
options = optimoptions(@fminunc,'Display','off','Algorithm','quasi-newton','FiniteDifferenceType','central');
options.FunctionTolerance=1e-4;
options.MaxIterations=10000;
options.MaxFunctionEvaluations=inf;
 for i=1:repeat
B0=rand(1,clus_num*2);rng;
[B_new,fval,exitf,output]=fminunc(@(B)costfn(B,X(:,n),Y,fis{n}),B0,options);
exitf;
if fval<=fval_min
    fval_min=fval;
    B_min=B_new;
end
end
minval(n)=fval_min;
fis{n}.output.mf(1).params=B_min(1:2);
fis{n}.output.mf(2).params=B_min(3:4);

end
 [MIN,J]=sort(minval); 
 id=J(1);
G(round)=id;
disp('----------Most Important Parameter Is:---------')
disp(G)
disp('----------MINIMUM ERROR VALUE IS:---------')
disp(MIN(1))
% inja mifahmim to round ghabli kodoom az hame mohemtar boode
disp('----------ROUND 1 COMPLETED---------')
disp('---------------------------------------')
disp('---------------------------------------')

%%%%%
% here ends round 1 and furthur rounds begin
%%%%%
  end
 if round>1
   
sr=int2str(round);
s=strcat('----------','ROUND ', sr,' BEGINS','----------');
disp(s)
disp('---------------------------------------')
disp('---------------------------------------')
 
 for n=1:vari_num
    
q=[G,n];
K=giverep(q,vari_num);
Xin=[];
for i=1:round
    if K(i) >= 1
        Xin(:,i)=X(:,i);
    end
end
sss=size(Xin);
nvarss=sss(2);
fis{n}=genfis3(Xin,Y,'sugeno',clus_num^round,opt);

fval_min=1e10;
options.MaxIterations=inf;
options.MaxFunctionEvaluations=inf;
for i=1:repeat
    B0=rand(1,(nvarss+1)*clus_num^round);rng;
[B_new,fval,exitf,output]=fminunc(@(B)costfnHY(B,Xin,Y,fis{n},clus_num^round),B0,options);
exitf;
if fval<=fval_min
    fval_min=fval;
    B_min=B_new;
end
end
minval(n)=fval_min;

rr=clus_num^round;
for w=1:rr
    % w represents rule number
   b=w*(nvarss+1);
   a=b-nvarss;
fis{n}.output.mf(w).params=B_min(a:b);
end

 end 
     

           
                
 [MIN,J]=sort(minval); 
 id=J(1);
G(round)=id;
sr=int2str(round);
s=strcat('----------','ROUND ', sr,' COMPLETED','----------');
disp(s)
disp('---------------------------------------')
disp('---------------------------------------')
disp('important parameters are respectively:')
disp(G)
disp('----------MINIMUM VALUE IS:---------')
disp(MIN(1))
end
end
%% 4: Results
best_fis=fis{G(end)};
ruleview(best_fis)
% here you can see all rules, all clusters and everything!
% THIS IS AWESOME!
%% END OF THE CODE
