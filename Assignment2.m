%Name: Sienna Sacramento
%CS 560 Spring 2020
%Professor Hasan
%Assignment 2 Question 1
%This program runs both the brute-force and the recursive algorithm
%for the maximum subarray problem. It also determines at which n elements
%does the recursive algorithm beat the brute-force. 

%creating array A with n values b/t 1 and 100
a = 1;
b = 100;

n = [5,10,25,50,100,200,300,400,500];
bruteTime = [0,0,0,0,0,0,0,0,0];
subTime = [0,0,0,0,0,0,0,0,0];
s = rng;
low = 1;

for x = 1: length(n)
    A = randi(100,1,n(x)); 
    high = n(x);
    timerVal = tic;
    tic
    %call brute force alg
    [maxLeft,maxRight,maxProfit] = bruteForceFindMax(A,low,high);
    toc
    bruteTime(x) = toc;
end

for x = 1: length(n)
    A = randi(100,1,n(x)); 
    high = n(x);
    timerVal = tic;
    tic
    %call max subarray alg
    change = makeChangeArray(A);
    [maxLeftsub,maxRightsub,maxProfitsub] = findMaxSubA(change,low,high);
    toc
    subTime(x) = toc;
end

plot(n,bruteTime);
hold on
plot(n,subTime);
legend({'Brute Force','Max SubArray'},'Location','northeast');
title("Brute Force v. Max SubArray");
xlabel("n elements");
ylabel("time in seconds");

%make change array
function change = makeChangeArray(A)
    change = zeros(1,length(A));
    for x = 2: length(A)
        change(x) = A(x) - A(x-1);
    end
end

%BRUTE-FORCE ALGORITHM
function [maxLeft,maxRight,maxProfit] = bruteForceFindMax(A,low,high)
    maxProfit = 0;
    maxLeft = 0;
    maxRight = 0;
    for i = low: high-1
        for j = low+1: high
            profit = A(j) - A(i);
            if profit > maxProfit
                maxLeft = i;
                maxRight = j;
                maxProfit = profit;
            end
        end
    end
end

%FIND-MAXIMUM-SUBARRAY ALGORITHM
function [alow,ahigh,asum] = findMaxSubA(A,low,high)
    if high == low
        alow = low;
        ahigh = high;
        asum = A(low);
        return;
    else
        mid = floor((low + high) / 2);
        [leftLow,leftHigh,leftSum] = findMaxSubA(A,low,mid);
        [rightLow,rightHigh,rightSum] = findMaxSubA(A,mid+1,high);
        [crossLow,crossHigh,crossSum] = findMaxCrossingSubA(A,low,mid,high);
        if (leftSum >= rightSum) && (leftSum >= crossSum)
            alow = leftLow;
            ahigh = leftHigh;
            asum = leftSum;
            return;
        elseif (rightSum >= leftSum) && (rightSum >= crossSum)
            alow = rightLow;
            ahigh = rightHigh;
            asum = rightSum;
            return;
        else
            alow = crossLow; 
            ahigh = crossHigh;
            asum = crossSum; 
            return;
        end
    end    
end

%FIND-MAX-CROSSING-SUBARRAY ALGORITHM
function [maxLeft,maxRight,leftRightSum] = findMaxCrossingSubA(A,low,mid,high)
    leftSum = -100;
    sum = 0;
    for i = mid:-1:low
        sum = sum + A(i);
        if sum > leftSum
            leftSum = sum;
            maxLeft = i;
        end
    end
    rightSum = -100;
    sum = 0;
    for j = mid+1: high
        sum = sum + A(j);
        if sum > rightSum
            rightSum = sum;
            maxRight = j;
        end
    end
    leftRightSum = leftSum + rightSum;
end
