%% Problem 3

x = linspace(-100, 100);
subplot(4,2,1);
y1 = sin(x);
plot(y1);
title('y1 = sin(x)');
subplot(4,2,2);
y2 = sin(x * 50);
plot(y2);
title('y2 = sin(50 * x)');
subplot(4,2,3);
y3 = 50 * sin(x);
plot(y3);
title('y3 = 50 * sin(x)');
subplot(4,2,4);
y4 = sin(x) + 50;
plot(y4);
title('y4 = sin(x) + 50');
subplot(4,2,5);
y5 = sin(x + 50);
plot(y5);
title('y5 = sin(x + 50)');
subplot(4,2,6);
y6 = 50 * sin(x * 50);
plot(y6);
title('y6 = 50 * sin(x * 50)');
subplot(4,2,7);
y7 =  x.*sin(x);
plot(y7);
title('y7 = x * sin(x');
subplot(4,2,8);
y8 = sin(x)./x;
plot(y8);
title('y8 = sin(x) / x');

%% Problem 4

x = linspace(-20, 20);
subplot(5,2,1);
y1 = sin(x);
plot(y1);
title('y1 = sin(x)');
subplot(5,2,2);
y2 = sin(x * 50);
plot(y2);
title('y2 = sin(50 * x)');
subplot(5,2,3);
y3 = 50 * sin(x);
plot(y3);
title('y3 = 50 * sin(x)');
subplot(5,2,4);
y4 = sin(x) + 50;
plot(y4);
title('y4 = sin(x) + 50');
subplot(5,2,5);
y5 = sin(x + 50);
plot(y5);
title('y5 = sin(x + 50)');
subplot(5,2,6);
y6 = 50 * sin(x * 50);
plot(y6);
title('y6 = 50 * sin(x * 50)');
subplot(5,2,7);
y7 =  x.*sin(x);
plot(y7);
title('y7 = x * sin(x');
subplot(5,2,8);
y8 = sin(x)./x;
plot(y8);
title('y8 = sin(x) / x');
subplot(5,2,9);
y9 = y1 + y2 + y3 + y4 + y5 ...
    + y6 + y7 + y8;
plot(y9);
title('y9 = y1 + y2 + ... + y8');
%% Problem 5

x = linspace(-20, 20, 41);
z = normrnd(1,41);
subplot(5,2,1);
y10 = z;
plot(y10);
title('y10 = z');
subplot(5,2,2);
y11 = z + x;
plot(y11);
title('y11 = z + x');
subplot(5,2,3);
y12 = z + sin(x);
plot(y12);
title('y12 = z + sin(x)');
subplot(5,2,4);
y13 = z .* sin(x);
plot(y13);
title('y13 = z * sin(x)');
subplot(5,2,5);
y14 = x .* sin(z);
plot(y14);
title('y14 = x * sin(z)');
subplot(5,2,6);
y15 = sin(x + z);
plot(y15);
title('y15 = sin(x + z)');
subplot(5,2,7);
y16 = z .* sin(50 * x);
plot(y16);
title('y16 = z * sin(50 * x)');
subplot(5,2,8);
y17 = sin(x + 50 * z);
plot(y17);
title('y17 = sin(x + 50 * z)');
subplot(5,2,9);
y18 = sin(x) ./ z;
plot(y18);
title('y18 = sin(x) / z');
subplot(5,2,10);
y19 = y10 + y11 + y12 + y13 + y14 ...
    + y15 + y16 + y17 + y18;
plot(y19);
title('y19 = y10 + y11 + ... + y18');

%% Problem 6

x = linspace(-20, 20, 41);
z = rand(1,41);
subplot(5,2,1);
y20 = z;
plot(y20);
title('y20 = z');
subplot(5,2,2);
y21 = z + x;
plot(y21);
title('y21 = z + x');
subplot(5,2,3);
y22 = z + sin(x);
plot(y22);
title('y22 = z + sin(x)');
subplot(5,2,4);
y23 = z .* sin(x);
plot(y23);
title('y23 = z * sin(x)');
subplot(5,2,5);
y24 = x .* sin(z);
plot(y24);
title('y24 = x * sin(z)');
subplot(5,2,6);
y25 = sin(x + z);
plot(y25);
title('y25 = sin(x + z)');
subplot(5,2,7);
y26 = z .* sin(50 * x);
plot(y26);
title('y26 = z * sin(50 * x)');
subplot(5,2,8);
y27 = sin(x + 50 * z);
plot(y27);
title('y27 = sin(x + 50 * z)');
subplot(5,2,9);
y28 = sin(x) ./ z;
plot(y28);
title('y28 = sin(x) / z');
subplot(5,2,10);
y29 = y20 + y21 + y22 + y23 + y24 ...
    + y25 + y26 + y27 + y28;
plot(y29);
title('y29 = y20 + y21 + ... + y28');

%% Problem 7

r1 = normrnd(0,1, 10000, 1);
r2 = normrnd(0,sqrt(4), 10000, 1);
r3 = normrnd(0,sqrt(16), 10000, 1);
r4 = normrnd(0, sqrt(256), 10000, 1);
subplot(2,2,1);
hist(r1);
subplot(2,2,2);
hist(r2);
subplot(2,2,3);
hist(r3);
subplot(2,2,4);
hist(r4);

%hist([r1, r2, r3, r4], 2000);
%% Problem 8

r6 = normrnd(10,1, 10000, 1);
r7 = normrnd(20,sqrt(4), 10000, 1);
r8 = normrnd(-10,1, 10000, 1);
r9 = normrnd(-20, sqrt(4), 10000, 1 );

subplot(2,2,1);
hist(r6);
subplot(2,2,2);
hist(r7);
subplot(2,2,3);
hist(r8);
subplot(2,2,4);
hist(r9);

%hist([r6, r7, r8, r9], 2000);

%% Problem 9 

r11 = rand(10000, 1);
r21 = sqrt(4) * rand(10000, 1);
r31 = sqrt(16) * rand(10000, 1);
r41 = sqrt(256) * rand(10000, 1);

subplot(2,2,1);
hist(r11);
subplot(2,2,2);
hist(r21);
subplot(2,2,3);
hist(r31);
subplot(2,2,4);
hist(r41);

%hist([r11, r21, r31, r41], 2000);

%% Problem 10

r61 = rand(10000, 1) + 10;
r71 = sqrt(4) * rand(10000, 1) + 20;
r81 = rand(10000, 1) - 10;
r91 = sqrt(4) * rand(10000, 1) - 20;

subplot(2,2,1);
hist(r61);
subplot(2,2,2);
hist(r71);
subplot(2,2,3);
hist(r81);
subplot(2,2,4);
hist(r91);

%hist([r61, r71, r81, r91], 2000);
