function [x,currinliers]=nextRANSAChypo(L,remadj,alladj,K,highthresh,numPairs,maxTrials,maxDataTrials,poptype,talk)

% hypo2 uses all adjacent pairs to compute inliers in the EM loop but still
% uses only remaining adjacent pairs in RANSAC (need to be changed in RANSAC)
% hypo3: changed to exclude any region processing

[H,currinliers,x]=ransacfitH(L,K,remadj,highthresh,numPairs,poptype,maxTrials,maxDataTrials,talk);

% EM on inliers and homography
[tempH,tempx]=rectifyOrthoR(L,K,currinliers,x,0);
tempinliers=findHinliers(tempH,L,highthresh).*alladj;
while sum(sum(tempinliers))>sum(sum(currinliers))
    if talk
        fprintf(1,'inliers icrease from %d to %d\n',sum(sum(currinliers)),sum(sum(tempinliers)));
    end
    currinliers=tempinliers;
    x=tempx;
    
    % fit new model and inliers
    [tempH,tempx]=rectifyOrthoR(L,K,currinliers,x,1);
    tempinliers=findHinliers(tempH,L,highthresh).*alladj;
end

[ind1,ind2]=find(currinliers>0);
ind=union(ind1,ind2);

if talk
    fprintf(1,'----\npercent inliers: %f\n',sum(sum(currinliers))/sum(sum(alladj)));
    fprintf(1,'orthogonal pairs: %d\n',sum(sum(currinliers)));
    fprintf(1,'line inliers: %d\n',length(ind));
    if talk>2, pause, else pause(1), end
end