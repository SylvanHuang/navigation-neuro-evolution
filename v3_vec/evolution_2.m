format long
rng_id = round(now*1000);
run_id = sprintf('%9.0f', rng_id);

rng(rng_id)

global experiment
global global_state
global draw
global draw_refresh_rate
global logger

experiment = run_id;
global_state = {};
draw = true;
draw_refresh_rate = 0.001;

log_folder = sprintf('logs/%s', experiment);
addpath('../maps', 'classes', 'utils', 'utils/genetic', log_folder);

logger = Logger(log_folder, 'simulation.log');
logger.debug(sprintf('Staring experiment: %s', experiment));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evolution Settings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
settings = {};
settings.netLayout = [9 10 2];
logger.debug('Net Layout: [9 3 2]');

settings.initPosition = reshape([40;40], [1, 1, 2]);
logger.debug('Start position: [40, 40]');
settings.targetPosition = reshape([210; 210], [1, 1, 2]);
logger.debug('End position: [210, 210]');
settings.radius = 10;
logger.debug(sprintf('Radius: %d', settings.radius));
settings.sensorAngles = [-60; -40; -20; 0; 20; 40; 60];
logger.debug('Sensor angles: [-61 -40 -20 0 20 40 60]');
settings.sensorLen = 40;
logger.debug(sprintf('Sensor len: %d', settings.sensorLen));
settings.maxSpeed = 15;
logger.debug(sprintf('Max speed: %d', settings.maxSpeed));
settings.initAngle = 0;
logger.debug(sprintf('Init angle: %d', settings.initAngle));
settings.duration = 1;
logger.debug(sprintf('Duration: %d', settings.duration));

settings.step_count = 250;
logger.debug(sprintf('Step count: %d', settings.step_count));
settings.gen_count = 500;
logger.debug(sprintf('Gen count: %d', settings.gen_count));
settings.pop_count = 100;
logger.debug(sprintf('Pop size: %d', settings.pop_count));

settings.cmap = create_cmap(settings.pop_count);
logger.debug('Map: Simple map');
settings.map = MapFactory.basic_map(250, 250, 20, 50, 3);
%logger.debug('Map: map_4_path_2.png');
%settings.map = MapFactory.from_img('../maps/map_4_path_2.png');
settings.net = initNet(settings.netLayout);
settings.robot = Robot(settings.radius, settings.sensorAngles, ...
    settings.sensorLen, settings.maxSpeed, settings.net);
body = get_body(settings.radius)';
settings.body = reshape(body, [length(body), 1, 2]);
save(sprintf('logs/%s/settings', experiment), 'settings')

% start with new (random init)
%Pop = generateWBs(settings.netLayout, settings.pop_count)';
% or load existing
Pop = load(sprintf('%s/pop-gen-%d.mat', 'logs/737176832', 219));
%Pop = Pop.Pop;

M=1;
lstring=size(Pop, 2);
Space=[-M*ones(1,lstring); M*ones(1,lstring)];  %pracovny priestor
Sigma=Space(2,:)/50;%prac ovny priestor mutacie

best_fitnesses = [];
best_genomes = [];
for gen = 1:settings.gen_count
    logger.debug(sprintf('Gen: %d: ',gen));
    save(sprintf('logs/%s/pop-gen-%d', experiment, gen), 'Pop');
    [Fit, dists, collis] = fitness_vec(Pop, settings.map, settings.net, ...
        settings.robot, settings.body, settings.initPosition, ...
        settings.targetPosition, settings.initAngle, settings.step_count, ...
        settings.cmap);
    disp('Distances:');
    dists
    save(sprintf('logs/%s/distances-gen-%d', experiment, gen), 'dists');
    disp('Collisions');
    collis
    save(sprintf('logs/%s/collisions-gen-%d', experiment, gen), 'collis');
    disp('Fitnesses');
    Fit
    save(sprintf('logs/%s/fit-gen-%d', experiment, gen), 'Fit');
    [BestGenome, BestFit]=selbest(Pop,Fit',[1,1,1,1,1]);
    Old=seltourn(Pop,Fit',15);
    Work1=selsus(Pop,Fit',30);
    Work2=seltourn(Pop,Fit',50);
    Work1=crossov(Work1,1,0);
    Work2=muta(Work2,0.1,Sigma,Space);
    Work2=mutx(Work2,0.1,Space);
    Pop=[BestGenome;Old;Work1;Work2];
end
logger.close()
