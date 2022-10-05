function ReExpand(inputfile)

% specify matlab binary file that is undatable output run on a collapsed depthscale
% Event layers are added back to the sequence and the core re-expanded to original length

% SP Obrochta

load(strrep(inputfile,'collapsed.mat','events.mat'),'Events')
load(inputfile)

expandmat = flipud([Events{:,[1,3:4]}]);

% index depthrange before adding anything else you'll be indexing the wrong positions
index1 = nan(length(depthrange),size(expandmat,1));
index2 = nan(length(depth),size(expandmat,1));
for j = 1:size(expandmat,1)
	index1(:,j) = depthrange < expandmat(j,3);
	index1(:,j) = depthrange < expandmat(j,3);
	index2(:,j) = depth < expandmat(j,3);
	index2(:,j) = depth < expandmat(j,3); 
end
index1 = logical(index1);
index2 = logical(index2);
% add back in the bed thickness
for j = 1:size(expandmat,1)
	depthrange(index1(:,j)) = depthrange(index1(:,j)) - expandmat(j,2);
	depth(index2(:,j)) = depth(index2(:,j)) -  expandmat(j,2);
	depth1(index2(:,j)) = depth1(index2(:,j)) -  expandmat(j,2);
	depth2(index2(:,j)) = depth2(index2(:,j)) -  expandmat(j,2);
	depthstart = depthstart - expandmat(j,2);
end
inputfile = strrep(inputfile,'collapsed','reexpanded');
save(strrep(inputfile,'txt','mat'))

printme = 1;
udplot

% save a new output file
if depthcombine == 1
	comtag = 'Yes';
elseif depthcombine == 0
	comtag = 'No'; 
end

% recalc sedrate
printsar = diff(depthrange) ./ diff(summarymat(:,1) / 1000);
printsar(end+1,:) = NaN;
index = printsar > 10^4;
printsar(index) = NaN;

fid_output = fopen(strrep(savename,'pdf','txt'),'w');
fprintf(fid_output,'%s',['Undatable run on ',datestr(now,31),'. nsim=',num2str(nsim),' bootpc=',num2str(bootpc,'%.2g'),' xfactor=',num2str(xfactor,'%.2g'),' combine=',comtag]);
fprintf(fid_output,'\r\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s','Depth','Median age','Mean age','95.4% age','68.2% age','68.2% age','95.4% age','Median SAR');
for j = 1:size(depthrange,1)
	fprintf(fid_output,'\r\n%f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.0f\t%.2f',depthrange(j),summarymat(j,1),summarymat(j,6),summarymat(j,2),summarymat(j,3),summarymat(j,4),summarymat(j,5),printsar(j));
end
fclose(fid_output);