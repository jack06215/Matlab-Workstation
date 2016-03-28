function result = isTOVP(VPTheta,VPRadius)
if cos(VPTheta(1) - VPTheta(2)) > 0 | cos(VPTheta(2) - VPTheta(3)) > 0 | cos(VPTheta(3) - VPTheta(1)) > 0
    result = 0;
    return;
else result = 1;
end