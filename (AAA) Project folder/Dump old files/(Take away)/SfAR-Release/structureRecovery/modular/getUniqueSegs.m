function [unique_segs r c v artlineinds]=getUniqueSegs(artlineinds)

artlineinds = triu(artlineinds+artlineinds');
[r,c,v]=find(artlineinds);
unique_segs=unique([r;c]);
