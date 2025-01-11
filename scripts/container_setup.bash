

mkdir -p catkin_ws/src && \
cd catkin_ws/src && \
git clone https://github.com/thien94/orb_slam3_ros.git && \
cd .. && \
catkin config --extend /opt/ros/noetic 
