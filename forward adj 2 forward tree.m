function price = BinomialTreeForwardDiscrete(S0, K, r, T, sigma, divs, divt, N)
% Binomial Tree Model of forward with discrete dividends
dt = T / N;
ddiv = ceil(divt * N / T) + 1;
divn = sum(size(divt)) - 1;
sigman = 0;
for i=1:1:divn
    if (i==1)
        before = 0;
    else
        before = divt(i-1);
    end
    sigman = sigman + (S0*sigma/(S0-sum(divs.*exp(-r*divt).*(i<=ddiv))))^2*(divt(i)-before);
end
sigman = sqrt((sigman + sigma^2 * (T-divt(divn))) / T);
u = exp(r * dt + sigman * sqrt(dt));
d = exp(r * dt - sigman * sqrt(dt));
p = (exp(r * dt) - d) / (u - d);
discount = exp(- r * dt);
for i = 1:(N+1)
    svals = zeros(1, i);
    for j = 1:i
        svals(j) = S0 * u^(i - 1) * (d/u)^(j - 1) - sum(divs .* exp(r*dt*(i-ddiv)) .* (i>=ddiv));
    end
    SVals{i} = svals;
end
PVals{N + 1} = max(K - SVals{N + 1}, 0);
for i = N:-1:1
    pvals = zeros(1, i);
    for j = 1:i
        Early = discount * (p * PVals{i + 1}(j) + (1 - p) * PVals{i + 1}(j + 1));
        Internal = max(K - SVals{i}(j), 0);
        pvals(j) = max(Early, Internal);
    end
    PVals{i} = pvals;
end
price = PVals{1};
% price = BinomialTreeForwardDiscrete(50,50,0.05,5/12,0.4,[2],[2/12],1000)
end

