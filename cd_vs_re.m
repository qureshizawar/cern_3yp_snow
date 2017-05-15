y = [1.2 0.8 0.6 0.5 0.45]
x = [100 500 1000 1500 2000]

a = [3 2 1.5 1.3 1.2]
b = [10 30 60 90 100]

x1 = linspace(100,2000,100)
x2 = linspace(10,100,100)

p1 = polyfit(x,y,4)
p2 = polyfit(b,a,4)

y1 = polyval(p1,x1)
y2 = polyval(p2,x2)
% plot(x,y,x1,y1)
plot(b,a,x2,y2)