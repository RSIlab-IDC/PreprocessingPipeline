%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Details:
% Name:     Pipeline_Stage03.m
% Authors:  Matan Sheskin
% Date:     September 30th, 2020
% Function: MAKE THE WORLD BETTER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Given the discussion in the GitHub project section of this repository, we
% are going for the leanest version of this action. This means that given a
% set of parameters, a suitable matrix is created and saved. No version
% control is supported.

%% Segment 1: Set parameters
% Attribute Creation
attrConditionID = unique(CHANNELLOG.conditionid);
attrTask = unique(CHANNELLOG.tid);
attrChannel = unique(CHANNELLOG.channelid);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Group attribute extraction
attGroupEMG = find(contains(attrChannel,'EMG'));

% TODO: Create more attribute groups
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Set values (for results matrix params)
valCond = '1';
valTask = 'SOFb1';
groupChannel = 'EMG';
valChannel = 'EMG_Corr_1';


%% Segment 2: Querying CHANNELLOG table for relevant lines (Logical Indexing)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: Questions:
% Q2.1:
% Is there a need to distinguished between participants who finished the
% experiment or not?
% I can check the number of 'tid' a participant has (according to pid) 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rowsQ = (strcmp(CHANNELLOG.conditionid,valCond) ...
    & strcmp(CHANNELLOG.tid,valTask) ...
    & strcmp(CHANNELLOG.channelid,valChannel));
channelLogQ = CHANNELLOG{rowsQ,:};

%% Segment 3: Appending table in loop

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% TODO: Questions: 
% Q3.1:
% Generalizing height selection request: Why not use append to tables?
% The need for NaN rows can be solved using fillers.
% Q3.2:
% Do I need to say where each row came from? Should it have ID? Should I
% inform chennlLogQ about successful exports?
% I can build something from channelLogQ because I am looping on it. I can
% add a column for successful exports and add dates (probably 'day' would
% serve better than exact seconds)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Base case

% Creating the necessary table with outermerge
for i=2:height(channelLogQ)
    
end
