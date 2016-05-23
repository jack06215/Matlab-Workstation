function Key_Down(src, event)
persistent cnt;
tmp = cnt;
if isempty(tmp)
    tmp = 1;
end

if(strcmp(event.Key, 'escape'))
    tmp = tmp + 1;
else
    tmp = tmp - 1;
end
if tmp < 1 || tmp == -1
    tmp = 1;
end
cnt = tmp;
disp(num2str(tmp));
end

