x = [265 400 500 700 950 1360 2080 2450 2940];
y = [1025 1400 1710 2080 2425 2760 3005 2850 2675];
xlen = length(x);
A = zeros(3*(xlen-1),3*(xlen-1)); 
B = zeros(3*(xlen-1),1);

B(1) = y(1);
for i = 1:xlen-2
    for j = 0:1
        B(2 * i + j) = y(i + 1);
    end
end

B(2 * xlen - 2)= y(xlen);

for i = 1:xlen-1
    for j = 0:2
        A(2*i - 1, 3*i - j) = x(i)^j;
    end
    for j = 0:2
        A(2*i, 3*i - j) = x(i + 1)^j;
    end
end

A(24,1) = 1;

for i = 1:xlen-2
   A(16+i,3*i+2) = -1;
   A(16+i,3*i-1) = 1;
   A(16+i,3*i-2) = 2*(x(i+1));
   A(16+i,3*i+1) = -2*(x(i+1));      
end

result = linsolve(A,B);
figure;
plot(x,y,'r*');
hold on;
xlim([0 3000]);
ylim([0 3500]);

for i = 1:xlen-1
    x_ = (x(i):1:x(i+1));
    y_ = result(3*i - 2)*(x_.^2) + result(3*i - 1)*x_ + result(3*i);
    plot(x_,y_);
end
