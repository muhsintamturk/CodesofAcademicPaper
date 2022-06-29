function  result=MoreForLessExpectedCapitalAndRuin(u,time,c,frequency,claimmean,refundAmount)
%u is initial capital
%c is premium
Dimension=160; %matrix dimension 
% grid size=1 (Delta t)  
A=single(zeros(Dimension));
Deltat=1;
A(1,1)=1;
count=1;
for ii=2:Dimension
    count=count+1
for jj=2:Dimension
    n=(ii-1)+c-(jj-1);
    sum1=0;
    if n<=(ii-1) && 0<=n
        A(ii,jj)=exp(-frequency)*claimprocess(n,Deltat,frequency,claimmean); 
    elseif n>(ii-1)
        for m=0:(ii-1)
            ttt=(m-(ii-1))/c;
            %tttt=Deltat+[((ii-1)-m)/c];
            tttt=Deltat-ttt;
            sum1=sum1+[(c-n+(ii-1))/(c-m+(ii-1))]*claimprocess(m,ttt,frequency,claimmean)...
                *claimprocess(n-m,tttt,frequency,claimmean);
        end
        A(ii,jj)=exp(-frequency)*sum1;
    else
        A(ii,jj)=0;
    
    end
end
end

A(:,1)=1-sum(A(:,2:Dimension)');

AA=A;

Cachback=single(zeros(Dimension));
Cachback(1:(refundAmount+1),1)=1;
kkk=1;
for jj=(refundAmount+2):Dimension
    Cachback(jj,kkk+1)=1;
    kkk=kkk+1;
end
 for jj=2:time
    if mod(jj+12,12)==0
    AA=AA*A*Cachback;
    else
       AA=AA*A;
    end
end

% NONRUIN(1,1)=sum(AA(3,2:Dimension));
% NONRUIN(2,1)=sum(AA(6,2:Dimension));
% NONRUIN(3,1)=sum(AA(11,2:Dimension));
% NONRUIN(4,1)=sum(AA(21,2:Dimension));
% result=NONRUIN;
RUIN(1,1)=AA(6,1);
RUIN(2,1)=AA(11,1);
RUIN(3,1)=AA(16,1);
RUIN(4,1)=AA(21,1);
capital(1,1)=sum([1:(Dimension-1)].*AA(6,2:Dimension));
capital(2,1)=sum([1:(Dimension-1)].*AA(11,2:Dimension));
capital(3,1)=sum([1:(Dimension-1)].*AA(16,2:Dimension));
capital(4,1)=sum([1:(Dimension-1)].*AA(21,2:Dimension));
result=table(capital,RUIN)
end

