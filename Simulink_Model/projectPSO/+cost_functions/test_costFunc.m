function test_costFunc()
try
	clf(34)
end

i = 0;
while true
	PA_silentFigure(34)
	grid minor
	hold all
	plot(i,rand,'o');
	i = i+1;

	drawnow()	

end
	
end