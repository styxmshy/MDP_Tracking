function printMetrics(metrics, MT_list, out_fname, seq_label,...
    metricsInfo, dispHeader, dispMetrics, padChar)
% print metrics
% 
% ...
%
% extended version with ID Measures
if length(metrics)==17
    printMetricsExt(metrics)
    return;
end

% Detections MODP/MODA metrics
if length(metrics)==9
    printMetricsDet(metrics)
    return;
end

% default names

if nargin<2
    MT_list=[];
end

if nargin < 3
    out_fname = 'mot_metrics.txt';
end

if nargin < 4
    seq_label = 'generic';
end

if nargin < 5
    metricsInfo.names.long = {'Recall','Precision','False Alarm Rate', ...
        'GT Tracks','Mostly Tracked','Partially Tracked','Mostly Lost', ...
        'False Positives', 'False Negatives', 'ID Switches', 'Fragmentations', ...
        'MOTA','MOTP', 'MOTA Log'};

    metricsInfo.names.short = {'Rcll','Prcn','FAR', ...
        'GT','MT','PT','ML', ...
        'FP', 'FN', 'IDs', 'FM', ...
        'MOTA','MOTP', 'MOTAL'};

    metricsInfo.widths.long = [6 9 16 9 14 17 11 15 15 11 14 5 5 8];
    metricsInfo.widths.short = [5 5 5 4 4 4 4 6 6 5 5 5 5 5];

    metricsInfo.format.long = {'.1f','.1f','.2f', ...
        'i','i','i','i', ...
        'i','i','i','i', ...
        '.1f','.1f','.1f'};

    metricsInfo.format.short=metricsInfo.format.long;    
end

if nargin<6
    dispHeader=1;
end
if nargin<7
    dispMetrics=1:length(metrics)-1;
end
if nargin<8
    padChar={' ',' ','|',' ',' ',' ','|',' ',' ',' ','| ',' ',' ',' '};
end

write_header = 0;
if ~exist(out_fname, 'file')
    write_header = 1;
end
out_fid = fopen(out_fname, 'a');


namesToDisplay=metricsInfo.names.long;
widthsToDisplay=metricsInfo.widths.long;
formatToDisplay=metricsInfo.format.long;

namesToDisplay=metricsInfo.names.short;
widthsToDisplay=metricsInfo.widths.short;
formatToDisplay=metricsInfo.format.short;


if dispHeader
    if write_header
        fprintf(out_fid, 'File');
    end
    for m=dispMetrics
        printString=sprintf('fprintf(''%%%is%s'',char(namesToDisplay(m)));',...
            widthsToDisplay(m),char(padChar(m)));        
        eval(printString);
        if write_header
            fprintf(out_fid, '\t');
            printString=sprintf('fprintf(out_fid, ''%%%is'',char(namesToDisplay(m)));',...
                widthsToDisplay(m));        
            eval(printString);
        end
    end
    fprintf('\t MT(%%)\t PT(%%)\t ML(%%)\n');
    if write_header
        fprintf(out_fid, '\t MT(%%)\t PT(%%)\t ML(%%)\n');
    end
end
fprintf(out_fid, '%s', seq_label);
for m=dispMetrics
    printString=sprintf('fprintf(''%%%i%s%s'',metrics(m));',...
        widthsToDisplay(m),char(formatToDisplay(m)),char(padChar(m)));
    eval(printString);
    
    fprintf(out_fid, '\t');
    printString=sprintf('fprintf(out_fid, ''%%%i%s'',metrics(m));',...
        widthsToDisplay(m),char(formatToDisplay(m)));
    eval(printString);
end

gt_count = metrics(4);
mt_count = metrics(5);
pt_count = metrics(6);
ml_count = metrics(7);

mt_percent = double(mt_count)/double(gt_count) * 100;
pt_percent = double(pt_count)/double(gt_count) * 100;
ml_percent = double(ml_count)/double(gt_count) * 100;

fprintf('%.2f\t %.2f\t %.2f\n', mt_percent, pt_percent, ml_percent);

fprintf(out_fid, '\t %.2f\t %.2f\t %.2f\n',...
    mt_percent, pt_percent, ml_percent);


fclose(out_fid);

% if ~isempty(MT_list)
%     MT_percent_list = MT_list ./ double(gt_count) * 100
% end





