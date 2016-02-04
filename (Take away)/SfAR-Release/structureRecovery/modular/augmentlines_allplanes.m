function [Xnew,Lines,seg,inliers]= augmentlines_allplanes (A,X,psegs,rsegs,goodinds,LS_c)
                                                           %plane segment numbers that have artlines
Xnew=zeros(2,size(A,1));
Lines=zeros(4,0);
seg=zeros(0);
inliers=cell(1,size(A,1));
for i=1:size(A,1)                                                       %for each plane segment
    Xnew(:,i)=X(:,psegs(A(i,1)));                                       %plane angles, to which this segment belongs
    pindex1=A(i,1);                                                     %plane #, to which this seg belongs
    %         LSpair1=LS_c(:,goodinds(1,rsegs(pindex1,:)));
    %         LSpair2=LS_c(:,goodinds(2,rsegs(pindex1,:)));
    %         LSn=[LSpair1,LSpair2];                                                      %lineNos that constitute cur seg
    %         mid=size(LSpair1,2);
    %
    %         [lines,indLSn2Lines,indLines2LSn]=unique(LSn','rows');
    %         lines=lines';
    %         indLines2LSn1=indLines2LSn(1:mid);
    %         indLines2LSn2=indLines2LSn(mid+1:end);
    %         % indLS=indLS';
    %         % indLines=indLines';
    %         currIn=zeros(size(lines,2));                                        %components of rects. (which line pairs intersect to form rects)
    %         for k=1:mid
    %             currIn(indLines2LSn1(k),indLines2LSn2(k))=1;
    %             currIn(indLines2LSn2(k),indLines2LSn1(k))=1;
    %         end
    %         %                 LS1_c=LS1_c-repmat([u0;v0],2,size(LS1_c,2));
    goodinds_curr = goodinds(:,rsegs(pindex1,:));
    [lines currInlier]=augmentlines_single(goodinds_curr,LS_c);
    Lines=[Lines lines];                                                %Lines is unique linesegments for all segments, accumulated in for loop
    seg1=ones(1,size(lines,2));
    zero1=zeros(1,size(seg,2));
    zero2=zeros(size(seg,1),size(seg1,2));
    seg=[seg zero2;zero1 seg1];                                         %append 1's in a new row and append zeros to existing seg, for dimension matching
    % if i==1
    % seg=seg1;
    % end
    % inl=zeros(size(LS1_c,2));
    % inl=inl==0;
    inliers{1,i}=currInlier;
end