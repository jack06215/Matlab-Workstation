function draw(f,vp0,vp_o,line)
figure, imshow(f),hold on;
for j = 1:size(vp0,1)
    if vp0(j,3) == 0
        plot([0 3000*vp0(j,1)] + size(f,2)/2,[0 3000*vp0(j,2)] + size(f,1)/2,'-p','color','r');
    else
        plot([0 vp0(j,1)] + size(f,2)/2,[0 vp0(j,2)] + size(f,1)/2,'-p','color','r');
    end
    % pause(0.5);
end
% plot([vp0(2,1), vp0(3,1)] + size(f,2)/2, [vp0(2,2), vp0(3,2)] + size(f,1)/2, '-.', 'Color', 'Black', 'LineWidth', 3);
foc = 675;
vp_o = vp_o.* foc./repmat(vp_o(:,3),1,3);
vp_o = vp_o(:,1:2);
% for j = 1:3
%     plot([0 vp_o(j,1)]+ size(f,2)/2,[0 vp_o(j,2)] + size(f,1)/2,'-p','color','b');
% end

% for j = 1:size(line,1)
%     plot(line(j,3:4),line(j,1:2),'Color','Yellow', 'LineWidth', 2);
% end

lt = max(min(min(vp0(:,2)),0),-2000) - 300;
rt = min(max(max(vp0(:,2)),640),2640) + 300;
tp = max(min(min(vp0(:,1)),0),-2000) - 300;
bm = min(max(max(vp0(:,1)),480),2640) + 300;
axis([lt rt tp bm]);