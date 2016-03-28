function badqinds=findbadquads(qadj,qseg,inpercent)

if nargin<3
    inpercent=zeros(1,length(qadj));
end

qadj=(qadj+qadj')>0;
size(qadj)
index=0;

conflicts=repmat(1-inpercent,length(inpercent),1);
for index=1:max(qseg)
    conflicts(qseg==index,qseg==index)=0;
end
size(conflicts)
while index<inf
    overlapconflicts=qadj.*conflicts;
    cumconflicts = sum(overlapconflicts);
    if any(cumconflicts)
        badqind=find(cumconflicts'>0.9*max(cumconflicts));
        qadj(badqind,:)=0;
        qadj(:,badqind)=0;
        conflicts(badqind,:)=0;
        conflicts(:,badqind)=0;
    else
        fprintf(1,'---\n %d iterations\n---\n',index+1);
        break;
    end
%     size(overlapconflicts), max(cumconflicts), size(cumconflicts), 
    badqind;
    index=index+1;
end

badqinds=find(sum(qadj)==0);