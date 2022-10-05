function [Collapsed,Events,Uncollapsed] = MakeCollapsedInput(Events,inputfile)

% Specify a delimited file (txt, excel) with the top and bottom depths in cm of event deposits
% Specify a properly formatted input file
% Events: 2-column: column 1: top depth (cm); column 2: bottom depth (cm)
% Output will be a collapsed input file. Run it with undatable, and save the .mat file
% Run ReExpand.m to on the saved .mat file

% SP Obrochta

id = 'MATLAB:table:ModifiedAndSavedVarnames';
warning('off',id)
Events = readtable(Events);
Uncollapsed = readtable(inputfile);
warning('on',id)

Events.length = Events{:,2} - Events{:,1};
Events.botc = nan(height(Events),1);

% asign the depths in the collapsed scale
Events.botc(end) = Events{end,2};

% add the depths from the bottom up to get the event layer depths in collapsed scale
for i = flip(1:height(Events) - 1)
	Events.botc(i) = Events.bottom(i) + sum(Events.length(i + 1:end));
end

% check for dated material in events and remove
index = ones(height(Uncollapsed),1);
for i = 1:height(Uncollapsed)
	for j = 1:height(Events)
		% check is base is in event layer
		if Uncollapsed{i,3} <= Events{j,2} && Uncollapsed{i,3} >= Events{j,1}
			index(i) = 0;
		% check if the top is in an event layer
		elseif Uncollapsed{i,2} >= Events{j,2} && Uncollapsed{i,3} <= Events{j,1}
			index(i) = 0;
		end
	end
end
% make logical
index = index == 1;
Uncollapsed = Uncollapsed(index,:);
Collapsed = Uncollapsed;

% work from the bottom up and add in the event lengths
for i = flip(1:height(Events))
	index = Uncollapsed{:,3} < Events{i,2};
	Collapsed{index,2:3} = Collapsed{index,2:3} + Events.length(i);
end
[~,Fnam] = fileparts(inputfile);
writetable(Collapsed,[Fnam '-collapsed.txt'],'Delimiter','\t')
save([Fnam '-events.mat'],'Events')