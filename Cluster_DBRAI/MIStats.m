function Gs = MIStats(data)

[l,n] = size(data);
len = n*(n-1)/2;
G = zeros(len,1);

I = 1;
for k = 1:(n-1)
    for kk = (k+1):n
        G(I) = mutualC_e(k,kk,[],data);
        I = I + 1;
    end
end

Gs = sort(G);
mn = 0.5*(Gs(1:end-1)+Gs(2:end));
f = diff(Gs)./mn;
% HalfFilterWidth = floor(0.5*len*0.01);
HalfFilterWidth = floor(0.5*len);
FilterWidth = 2*HalfFilterWidth; % force even width
g = filter(ones(1,FilterWidth)/FilterWidth,1,f);
figure, plot(Gs), grid on, xlabel('index'); ylabel('MI value'); title('sorted MI value');
figure, 
plot(f,'b'); 
hold on; 
plot(g(HalfFilterWidth:end),'r','linewidth',2); 
hold off; 
grid on
xlabel('index');
% legend('normalized diff', sprintf('moving average: width=%d',FilterWidth));

% figure, plot(Gs), grid on
% figure, plot(diff(Gs)./Gs(1:end-1));