function digitC = bign(digitA,digitB)
% C =  A * B, while A ,B and C are all digit characters.
% A is multipled.
% A and B are both char.
digitA = fliplr(digitA);
digitB = fliplr(digitB);
nA = length(digitA);
nB = length(digitB);
value = single(zeros(1,nA+nB+1));

for j = 1:nB
    for i =1:nA
        value(i+j-1) = value(i+j-1)+(digitA(i)-'0')*(digitB(j)-'0');
    end
end


for j=1:(nA+nB)
       value(j+1) = value(j+1) + floor(value(j) /10);
       value(j) = mod(value(j),10);       
end

i = length(value);
while(value(i)==0)
    i=i-1;
end
count = 0;
for j = i :-1:1
    count = count+1;
    digitC(count) = char(value(j)+'0');
end

