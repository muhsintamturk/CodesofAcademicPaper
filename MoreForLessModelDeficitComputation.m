function  result=MoreForLessModelDeficitComputation(u,time,c,frequency,claimmean,cachbackamount)
%u is initial capital
%c is premium
Dimension=225; %matrix dimension
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
    if c>(jj-1) || -1<n
        A(ii,jj)=exp(-frequency)*claimprocess(n,Deltat,frequency,claimmean); 
    elseif n>(ii-1)
        for m=0:(ii-1)
            ttt=(m-(ii-1))/c;
            tttt=Deltat+[((ii-1)-m)/c];
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
Cachback(1:(cachbackamount+1),1)=1;
kkk=1;
for jj=(cachbackamount+2):Dimension
    Cachback(jj,kkk+1)=1;
    kkk=kkk+1;
end
 for jj=2:(time-1)
    if mod(jj+12,12)==0
    AA=AA*A*Cachback;
    else
       AA=AA*A;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
XX=AA;

expextedcapitalbeforeruin(1,1)=sum([1:(Dimension-1)].*XX(11,2:Dimension));
expextedcapitalbeforeruin(2,1)=sum([1:(Dimension-1)].*XX(16,2:Dimension));
expextedcapitalbeforeruin(3,1)=sum([1:(Dimension-1)].*XX(21,2:Dimension));
expextedcapitalbeforeruin(4,1)=sum([1:(Dimension-1)].*XX(26,2:Dimension));
aa=expextedcapitalbeforeruin(1,1);
bb=expextedcapitalbeforeruin(2,1);
cc=expextedcapitalbeforeruin(3,1);
dd=expextedcapitalbeforeruin(4,1);



S1=exp(-frequency)*frequency;
S2=exp(-frequency)*(frequency^2)/2;
S3=exp(-frequency)*(frequency^3)/6;

sizee=250;
probability_of_aa=S1*gampdf(ceil(aa+c):sizee,1,claimmean)+...
    S2*gampdf(ceil(aa+c):sizee,2,claimmean)+...
    S3*gampdf(ceil(aa+c):sizee,3,claimmean);

probability_of_bb=S1*gampdf(ceil(bb+c):sizee,1,claimmean)+...
    S2*gampdf(ceil(bb+c):sizee,2,claimmean)+...
    S3*gampdf(ceil(bb+c):sizee,3,claimmean);

probability_of_cc=S1*gampdf(ceil(cc+c):sizee,1,claimmean)+...
    S2*gampdf(ceil(cc+c):sizee,2,claimmean)+...
    S3*gampdf(ceil(cc+c):sizee,3,claimmean);

probability_of_dd=S1*gampdf(ceil(dd+c):sizee,1,claimmean)+...
    S2*gampdf(ceil(dd+c):sizee,2,claimmean)+...
    S3*gampdf(ceil(dd+c):sizee,3,claimmean);

deficit_aa=(ceil(aa+c):sizee)-(aa+c);
deficit_bb=(ceil(bb+c):sizee)-(bb+c);
deficit_cc=(ceil(cc+c):sizee)-(cc+c);
deficit_dd=(ceil(dd+c):sizee)-(dd+c);

e_aa=sum(deficit_aa.*probability_of_aa)
e_bb=sum(deficit_bb.*probability_of_bb)
e_cc=sum(deficit_cc.*probability_of_cc)
e_dd=sum(deficit_dd.*probability_of_dd)



% plot(deficit_aa,probability_of_aa)
% hold on 
% plot(deficit_bb,probability_of_bb)
% hold on 
% plot(deficit_cc,probability_of_cc)
% hold on 
% plot(deficit_dd,probability_of_dd)


end