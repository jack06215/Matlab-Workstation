function B=sepscoreNew(arts,L1,L2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

B=0;
x=[L1(1,:),L2(1,:)];
y=[L1(2,:),L2(2,:)];
P=convhull(x,y);
acurr=[arts(1:2,1),arts(3:4,1)];
Pcurr=cutpolygon([x(P); y(P)]',acurr',1);

if size(Pcurr,1)==0
    return
end

        [in,on]=inpolygon(L1(1,:),L1(2,:),Pcurr(:,1)',Pcurr(:,2)');
        in1=in+on;
        [in,on]=inpolygon(L2(1,:),L2(2,:),Pcurr(:,1)',Pcurr(:,2)');
        in2=in+on;
        
        out1=~(in1);
        out1=+out1;
        out2=~(in2);
        out2=+out2;
if size(find(out2),2)+size(find(out1),2)==0

    return
end

        A=size(find(in1),2)+size(find(out2),2);
        B=size(find(in2),2)+size(find(out1),2);
        A=A/(size(in1,2)+size(in2,2));
        B=B/(size(in1,2)+size(in2,2));
        B=max([A,B]);
        
end

