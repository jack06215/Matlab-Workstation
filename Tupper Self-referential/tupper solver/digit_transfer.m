function digitB = digit_transfer(baseA,baseB,digitA)
% description: 
%               transfer digitA in baseA into digitB in baseB.
% digitA and digitB is char.
% Note:!!!!!!! baseA must be larger than baseB.
% for example.
% digitA = '11001';
% digit_transfer(2,10,digitA)

baseA = single(baseA);
baseB = single(baseB);
value = zeros(10000,1)*single(0);
len = 1;
k=1;
while(k<=length(digitA))
    BitValue = digitA(k) - '0';
    for i=1:len
        value(i) = baseA*value(i);
    end
    value(1)  =value(1)+BitValue;
   
    for i=1:len
        value(i+1) =value(i+1)+floor(value(i) / baseB);
        value(i) = mod(value(i),baseB);
    end
    
    if value(len)~=0 
        len = len+1;
    end
     k = k+1;
end

count =0;
for i =(len-1):-1:1
    count = count+1;
    if value(i)<=9
        digitB(count) = char(value(i)+'0');
    else
        digitB(count) = char(value(i)+'A'-10);
    end
end
