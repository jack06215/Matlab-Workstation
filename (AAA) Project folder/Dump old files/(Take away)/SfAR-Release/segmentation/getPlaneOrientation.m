function [X,inliers,numhyp] = getPlaneOrientation(Ladj,L,K,highthresh,numPairs,maxTrials,maxDataTrials,poptype,talk)
%GETPLANEORIENTATION 
% inputs
% Ladj: adjacency matrix for line segments
% L: line segments in vector format
% K: camera matrix
% outputs
% X: alpha and beta for each plane hypothesis
% inliers: inliers for each plane hypothesis
% numhyp: number of plane hypothesis

Ladj=triu(Ladj);

remadj=Ladj;
X=zeros(2,0);
numhyp=0;
inliers=cell(0);

while 1
    [x,currinliers]=nextRANSAChypo(L,remadj,Ladj,K,highthresh,numPairs,maxTrials,maxDataTrials,poptype,talk);
    inliers=[inliers,currinliers];
    X=[X,x];
    remadj=remadj-currinliers;
    numhyp=numhyp+1;

    % show the inliers' line segments
    [ind1,~]=find(currinliers>0);

    if length(ind1)<max([10,0.1*sum(sum(Ladj))])
        numhyp=numhyp-1;
        fprintf(1,'<> not enough pairs rectified THIS time\n %d of %d regions rectified\n\n',sum(sum(remadj)),sum(sum(Ladj)));
        break;
    elseif sum(sum(remadj))<max([20,0.1*sum(sum(Ladj))])
        fprintf(1,'<> not enough adjacent pairs remain\n only %d of %d remaining\n\n',sum(sum(remadj)),sum(sum(Ladj)));
        break;
    end
end



end

