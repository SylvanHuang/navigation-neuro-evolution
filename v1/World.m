classdef World < handle    
    properties
        map
        cmap
        robots
    end
    
    methods
        function world = World(map)
            world.map = map;
            world.cmap = [
                0 0 0; ... % obstacle color
                1 1 1; ... % free color
                220/255 220/255 200/255; ... % robot color
                30/255 144/255 255/255; ...  % robot direction line color
                124/255 252/255 0
                ]; 
            world.robots = {};
        end
        
        function addObstacles(world, indexes)
            % directly writing to map matrxix because they are not going to
            % move
            for i = 1:length(indexes)
                world.map(indexes(1,i),indexes(2,i)) = 2;
            end %for
        end %function - addObject
        
        %function mapRobots = addRobots(world, robotsWithPosition)
        %
        %end
        
        function mapRobot = addRobot(world, robot, position)
            mapRobot = MapRobot(length(world.robots)+1, robot, position);
            world.robots{end+1} = mapRobot; 
        end % function
        
        function draw(world)
            cleanMap = world.map;
            mapWithRobots = world.putAllOnMap(cleanMap);
            image(mapWithRobots, 'CDataMapping', 'direct');
            colormap(world.cmap);
        end %function - draw
        
        function area = getArea(world, coordinates)
            area = [];
            for i = 1:length(coordinates)
                mapValue = world.map(coordinates(1,i), coordinates(2, i));
                if mapValue == 2
                    area = [area; 0];
                else
                    area = [area; 1];
                end
            end % 
        end % end getCoordinates
        
        % private
        function mapWithRobot = putOnMap(world, map, mapRobot)
            for i = 1:length(mapRobot.robot.me)
                map(mapRobot.robot.me(1,i)+mapRobot.position(1), ...
                    mapRobot.robot.me(2,i)+mapRobot.position(2)) = 3;
            end %for
            % add direction line
            [x, y] = bresenham(0,0,mapRobot.robot.nose(1), mapRobot.robot.nose(2));
            for i = 1:length(x)
                world.map(x(i)+mapRobot.position(1), y(i)+mapRobot.position(2)) = 4;
            end
            
            for i = 1:length(mapRoot.robot.scan)
                map(mapRobot.robot.scan(1, i) + mapRobot.position
            mapWithRobot = map;
        end % function
        
        % private
        function mapWithRobots = putAllOnMap(world, map)
            for i = 1:length(world.robots)
                mapWithRobots = world.putOnMap(map, world.robots{i});
            end % for
        end % function
    end
end
