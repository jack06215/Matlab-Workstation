function c = objectivecost2(x0,d,y)

C = exp(-x0.*d(1,:)) - y(1,:);
C = C.*C;
c = sum(C);
end

