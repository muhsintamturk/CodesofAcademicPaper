function  result=ReinsuraneModelWithExponentialPremium(u,time,c,a,frequency,claimmean,retentionlevel)
%Note that here ct=c-c_r(exp(at)-1) (exact premium)
% u is initial capital
% a is constant of exponential premium.
tic
Dimension=200;
A=single(zeros(Dimension));
Deltat=1;
A(1,1)=1;
count=1;
for ii=2:Dimension
    count=count+1
for jj=2:Dimension
    n=(ii-1)+(c/a)*(exp(a)-1)-(jj-1);
    
    sum1=0;
    
    if n<=(ii-1) && 0<=n
        n=floor(n);
        A(ii,jj)=exp(-frequency)*claimprocess(n,Deltat,frequency,claimmean); 
    elseif n>(ii-1)
        %n=floor(n);
        for m=0:(ii-1)   %l=m
            %ttt=(m-(ii-1))/c;
            ttt=(1/a)*log((a/c)*(m-(ii-1))+1);     
            tttt=Deltat-ttt;
            sum1=sum1+[((ii-1)+(c/a)*(exp(a)-1)-n)/((ii-1)+(c/a)*(exp(a)-1)-m)]*claimprocess(m,ttt,frequency,claimmean)...
                *claimprocess(round(n-m),tttt,frequency,claimmean);
        end
        A(ii,jj)=exp(-frequency)*sum1;
    else
        A(ii,jj)=0;
    
    end
end
end

A(:,1)=1-sum(A(:,2:Dimension)');
%%%%%%%%%%%%%%%%%%%%%%%%%%

C=A;
InjectionMatrix=single(zeros(Dimension));
InjectionMatrix(1,1)=1;
pppp=retentionlevel+1;
for iii=2:pppp;
InjectionMatrix(iii,pppp)=1;
end
for jjj=(pppp+1):Dimension;
    InjectionMatrix(jjj,jjj)=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%

%pp=mpower(C*InjectionMatrix,time-1)*C;

ExpectedInjectionAmount(1,1)=0;
ExpectedInjectionAmount(2,1)=0;
ExpectedInjectionAmount(3,1)=0;
ExpectedInjectionAmount(4,1)=0;

 G=A;
 x=1:1:retentionlevel;
    y=retentionlevel-x;
    up=retentionlevel+1;


for j=2:time;
    G=mtimes(mtimes(G,InjectionMatrix),A);
    

ExpectedInjectionAmount(1,1)=ExpectedInjectionAmount(1,1)+sum(y.*G(6,2:up));
ExpectedInjectionAmount(2,1)=ExpectedInjectionAmount(2,1)+sum(y.*G(11,2:up));
ExpectedInjectionAmount(3,1)=ExpectedInjectionAmount(3,1)+sum(y.*G(16,2:up));
ExpectedInjectionAmount(4,1)=ExpectedInjectionAmount(4,1)+sum(y.*G(21,2:up));

    
end
% NONRUINwithreinsurance(1,1)=sum(G(11,2:Dimension));
% NONRUINwithreinsurance(2,1)=sum(G(21,2:Dimension));
% NONRUINwithreinsurance(3,1)=sum(G(31,2:Dimension));
% NONRUINwithreinsurance(4,1)=sum(G(41,2:Dimension));
% NONRUINwithreinsurance(1,1)=sum(G(21,2:Dimension));
% NONRUINwithreinsurance(2,1)=sum(G(26,2:Dimension));
% NONRUINwithreinsurance(3,1)=sum(G(31,2:Dimension));
% NONRUINwithreinsurance(4,1)=sum(G(36,2:Dimension));
% NONRUINwithreinsurance(1,1)=sum(G(21,2:Dimension));
AA=G;

nonRUIN(1,1)=1-AA(6,1);
nonRUIN(2,1)=1-AA(11,1);
nonRUIN(3,1)=1-AA(16,1);
nonRUIN(4,1)=1-AA(21,1);

RUIN(1,1)=AA(6,1);
RUIN(2,1)=AA(11,1);
RUIN(3,1)=AA(16,1);
RUIN(4,1)=AA(21,1);

capital(1,1)=sum([1:(Dimension-1)].*AA(6,2:Dimension));
capital(2,1)=sum([1:(Dimension-1)].*AA(11,2:Dimension));
capital(3,1)=sum([1:(Dimension-1)].*AA(16,2:Dimension));
capital(4,1)=sum([1:(Dimension-1)].*AA(21,2:Dimension));
result=table(capital,RUIN,nonRUIN,ExpectedInjectionAmount)
toc
end