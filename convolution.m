function con=convolution(n,k,claimmean)
if n==0;
    con=1;
elseif k==0;
    con=0;
else
    
    con=gampdf(n,k,claimmean); % claimmean is mean of exponential dist.
end


end