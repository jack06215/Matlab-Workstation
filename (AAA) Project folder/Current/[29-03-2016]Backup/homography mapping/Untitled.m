% [0,0] [10,0], [0,10], [10,10]
X1=[0,0];
X2=[2,0];
X3=[2,2];
X4=[0,2];
X=[63,51];%,X3(1),X4(1)];
Y=[202,282];%,X3(2),X4(2)];
somePt = [51,282];
figure, hold on;
intersect = inpolygon(intpt(1),intpt(2),X,Y);
intersect
plot(X,Y,'Color', 'Red', 'LineWidth', 3);
plot(somePt(1), somePt(2), 'o', 'Color', 'Green', 'LineWidth', 3);
