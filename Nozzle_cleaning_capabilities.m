t = 2*10^-3;
angle = 45;
pipe = 28.97;
consumption = 0.0069
angle_factor = (-1/35)*angle + 18/7
spot_size = 28*(2.2*(28/12.4))*angle_factor
Area_cps = spot_size/t
max_speed = (Area_cps/pipe)/1000
clean_time = 1/consumption
length_cleaned = max_speed*clean_time


