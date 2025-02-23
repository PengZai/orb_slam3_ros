import os
import numpy as np 
from evo.tools import file_interface
from evo.core.trajectory import PoseTrajectory3D
import shutil




sequence_name = '1018_00'
sensor_type = 'stereo_inertial'
filename_prefix = '_'.join(['orbslam3', sensor_type,'for', sequence_name, 'img10hz600p'])

if not os.path.exists(os.path.join(sequence_name, filename_prefix)):
    os.makedirs(os.path.join(sequence_name, filename_prefix))

testfolder_names = [f for f in os.listdir(os.path.join(sequence_name, filename_prefix))]
current_testfolder_name = '_'.join(['test', str(len(testfolder_names))])
if not os.path.exists(os.path.join(sequence_name, filename_prefix, current_testfolder_name)):
    os.makedirs(os.path.join(sequence_name, filename_prefix, current_testfolder_name))
if not os.path.exists(os.path.join(sequence_name, filename_prefix, current_testfolder_name, 'config')):
    os.makedirs(os.path.join(sequence_name, filename_prefix, current_testfolder_name, 'config'))    


camera_filename = '_'.join([filename_prefix, 'cam_traj'])
keyframe_filename = '_'.join([filename_prefix, 'kf_traj'])
filename_suffix = '.txt'
shutil.copy(os.path.join(sequence_name, camera_filename+filename_suffix), os.path.join(sequence_name, filename_prefix, current_testfolder_name, camera_filename+filename_suffix))
shutil.copy(os.path.join(sequence_name, keyframe_filename+filename_suffix), os.path.join(sequence_name, filename_prefix, current_testfolder_name, keyframe_filename+filename_suffix))
shutil.copy(os.path.join('../../config', ('-').join([s.capitalize() for s in sensor_type.split('_')]), 'BotanicGarden.yaml'), os.path.join(sequence_name, filename_prefix, current_testfolder_name, 'config', 'BotanicGarden.yaml'))




# # VLP16 in RGB0 coordinates
# sensor_coordinate_transform_matrix = np.array([
#     [0.0238743541600432,-0.999707744440396,0.00360642510766516,0.138922870923538],  
#     [-0.00736968896588375,-0.00378431903190059,-0.999965147452649 ,-0.177101909101325],  
#     [0.999687515506770,0.0238486947027063,-0.00745791352160211,-0.126685267545513],  
#     [0.0,0.0,0.0,1.0]
# ])

# keep same, it seems we don't need to transfer to VLP16 coordinates, which is more precise
# sensor_coordinate_transform_matrix_for_camera_frame = np.array([
#     [1.,0,0,0],  
#     [0,1.,0,0],  
#     [0,0,1.,0],  
#     [0,0,0,1.0]
# ])

# VLP16 in Xsens coordinates
sensor_coordinate_transform_matrix_for_camera_frame = np.array([
    [0.999678872580465,0.0252865664429322,0.00150422292234868,0.0584867781527745],  
    [-0.0252723438960774,0.999649431893338,-0.0078025434141585,0.00840419966766332],  
    [-0.00170103929405540,0.00776298237926191,0.99996789371916,0.168915521980526],  
    [0.0,0.0,0.0,1.0]
])


# because KeyFrame is in Xsens coordinates, so we need to transfer it to RGB0 coordinates
# RGB0 in Xsens coordinates
# sensor_coordinate_transform_matrix_for_key_frame = np.array([
#     [-0.00140533,-0.00896721,0.99995881,0.18377395],
#     [-0.99999022,0.0042065,-0.00136765,0.14789743],
#     [-0.00419407,-0.99995095,-0.00897304,-0.0087318],
#     [0.0,0.0,0.0,1.0]
# ])

# VLP16 in Xsens coordinates
sensor_coordinate_transform_matrix_for_key_frame = np.array([
    [0.999678872580465,0.0252865664429322,0.00150422292234868,0.0584867781527745],  
    [-0.0252723438960774,0.999649431893338,-0.0078025434141585,0.00840419966766332],  
    [-0.00170103929405540,0.00776298237926191,0.99996789371916,0.168915521980526],  
    [0.0,0.0,0.0,1.0]
])



# seems x in camera frame of orbslam system is z in BotanicGarden, and y is -y
system_coordinate_transform_matrix_for_camera_frame = np.array([
    [1., 0,  0.,    0],  
    [0., 1., 0.,  0],  
    [0.,  0., 1.,  0],  
    [0,  0,  0,  1.0]
])


# seems x in key frame of orbslam system is -z in BotanicGarden
# system_coordinate_transform_matrix_for_key_frame = np.array([
#     [0., 0.,  -1.,  0],  
#     [0., 1.,  0.,   0],  
#     [1., 0.,   0.,  0],  
#     [0.,  0,   0,   1.0]
# ])
system_coordinate_transform_matrix_for_key_frame = np.array([
    [0., 1,  0.,    0],  
    [-1., 0., 0.,  0],  
    [0.,  0., 1.,  0],  
    [0,  0,  0,  1.0]
])



# keep same
# system_coordinate_transform_matrix = np.array([
#     [1.,0,0,0],  
#     [0,1.,0,0],  
#     [0,0,1.,0],  
#     [0,0,0,1.0]
# ])



def invert_transformation_matrix(T):
    """
    Computes the inverse of a 4x4 homogeneous transformation matrix.
    
    Parameters:
        T (numpy.ndarray): 4x4 transformation matrix
    
    Returns:
        numpy.ndarray: 4x4 inverse transformation matrix
    """
    # Extract rotation (R) and translation (t)
    R = T[:3, :3]  # 3x3 rotation matrix
    t = T[:3, 3]   # 3x1 translation vector

    # Compute the inverse transformation
    R_inv = R.T  # Transpose of rotation matrix
    t_inv = -R_inv @ t  # Compute new translation

    # Construct the inverse transformation matrix
    T_inv = np.eye(4)
    T_inv[:3, :3] = R_inv
    T_inv[:3, 3] = t_inv

    return T_inv

camera_traj = file_interface.read_tum_trajectory_file(os.path.join(sequence_name, camera_filename+filename_suffix))
camera_traj.timestamps = camera_traj.timestamps / 1e9
keyframe_traj = file_interface.read_tum_trajectory_file(os.path.join(sequence_name, keyframe_filename+filename_suffix))
keyframe_traj.timestamps = keyframe_traj.timestamps / 1e9
traj_dicts = [
    {"type":"cam", "traj":camera_traj},
    {"type":"key_frame", "traj":keyframe_traj}
]

for traj_dict in traj_dicts:

    transformed_poses = []
    for pose in traj_dict['traj'].poses_se3:

        if traj_dict['type'] == "cam":
        # Apply the transformation
            transformed_pose_matrix = system_coordinate_transform_matrix_for_camera_frame @ invert_transformation_matrix(sensor_coordinate_transform_matrix_for_camera_frame) @ pose
        else: 
            transformed_pose_matrix = system_coordinate_transform_matrix_for_key_frame @ invert_transformation_matrix(sensor_coordinate_transform_matrix_for_key_frame) @ pose

        # Append transformed pose as SE3 object
        transformed_poses.append(transformed_pose_matrix)

    
    traj = PoseTrajectory3D(
        poses_se3=transformed_poses,
        timestamps=traj_dict['traj'].timestamps
    )

    if traj_dict['type'] == "cam":
        file_interface.write_tum_trajectory_file(os.path.join(sequence_name, filename_prefix, current_testfolder_name, camera_filename + "_coordinate_aligned"+filename_suffix), traj)
    else: 
        file_interface.write_tum_trajectory_file(os.path.join(sequence_name, filename_prefix, current_testfolder_name, keyframe_filename + "_coordinate_aligned"+filename_suffix), traj)

