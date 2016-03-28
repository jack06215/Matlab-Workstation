function [goodquads2,goodqseg2,goodqadj2,badquads2,badqseg2,goodqadj2vis,goodinds] = removeConflicts(inpercent,quads,qadj,qseg,inds)
%REMOVECONFLICTS

% inputs
% inpercent: the score assigned to each quad
% quads: the end points of the quads detected
% qadj: the adjacency matrix for quads
% qseg: segmentation of quads into planes
% inds:
% outputs



inpercent1=inpercent;
inpercent1(inpercent1>0.9)=0.9;
badqinds2=findbadquads(qadj,qseg,inpercent1);

goodquads2=quads; 
goodqadj2=qadj; 
goodqseg2=qseg; 
goodinds=inds;
goodquads2(:,badqinds2)=[];
goodqseg2(badqinds2)=[];
goodinds(:,badqinds2)=[];
goodqadj2(:,badqinds2)=[];
goodqadj2(badqinds2,:)=[];
badquads2=quads(:,badqinds2);
badqseg2=qseg(badqinds2);
badqadj2=qadj(:,badqinds2);
badqadj2=badqadj2(badqinds2,:);

goodqadj2vis=qadj; 
goodqadj2vis(:,badqinds2)=0;
goodqadj2vis(badqinds2,:)=0;

end

