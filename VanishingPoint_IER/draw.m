function draw(f,vp0,vp_o,line)
figure, imshow(f),hold on;
myColor = ['r', 'g', 'cyan'];
for j = 1:size(vp0,1)
    if vp0(j,3) == 0
        %plot([0 3000*vp0(j,1)] + size(f,2)/2,[0 3000*vp0(j,2)] + size(f,1)/2,'-p','color',myColor(j));
    else
        plot([0 vp0(j,1)] + size(f,2)/2,[0 vp0(j,2)] + size(f,1)/2,'o','color',myColor(j));
    end
end

% foc = 675;
% vp_o = vp_o.* foc./repmat(vp_o(:,3),1,3);
% vp_o = vp_o(:,1:2);
% for j = 1:3
%     plot([0 vp_o(j,1)]+ size(f,2)/2,[0 vp_o(j,2)] + size(f,1)/2,'-p','color','b');
% end
% 
% for j = 1:size(line,1)
%     plot(line(j,3:4),line(j,1:2),'k');
% end

lt = max(min(min(vp0(:,1)),0),-2000) - 300;
rt = min(max(max(vp0(:,1)),640),2640) + 300;
tp = max(min(min(vp0(:,2)),0),-2000) - 300;
bm = min(max(max(vp0(:,2)),480),2640) + 300;
axis([lt rt tp bm]);