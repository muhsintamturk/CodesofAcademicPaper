function result=claimprocess(n,time,frequency,claimmean)

sum=0;
sumeach=0;
if time==0
    result=0;
else
for k=0:n; 

    sumeach=(convolution(n,k,claimmean)*(frequency*time)^(k))/factorial(k);
   
    sum=sum+sumeach;
end
result=sum;
end

end