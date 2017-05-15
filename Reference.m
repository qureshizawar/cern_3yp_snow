xcleaned = 100;
cleandistance = 220;
xfinishclean = xcleaned+cleandistance;
vref = 5;
vclean = 2.5;


%ref = zeros(1, 2800);
for x = 1:2800
   if x < xcleaned
       ref(x) = vref;
   end
   
   if x > xfinishclean
       ref(x) = vref;
   end
   
   if x > xcleaned && x < xfinishclean
       ref(x) = vclean;
   end
   
end

ref(ref == 0) = [];



plot(ref)
axis([0 2800 0 7])
ylabel('Reference velocity (ms-1)')
xlabel('Distance along beam pipe(m)')