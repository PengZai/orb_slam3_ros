
DATASET="BotanicGarden"
DIR="1018_00"
TEST_DIR="test_0"
SENSOR_TYPE="monocular_inertial"
ESITMATED_FOLDER="orbslam3_${SENSOR_TYPE}_for_${DIR}_img10hz600p"
REFERENCE="${DIR}_GT_output.txt"

# cam
evo_rpe tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.txt ${DATASET}/$DIR/$REFERENCE --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_rpe_cam_traj > ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/rpe_${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.log
evo_ape tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.txt ${DATASET}/$DIR/$REFERENCE  --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_ape_cam_traj > ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/ape_${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.log
evo_ape tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.txt ${DATASET}/$DIR/$REFERENCE --align --pose_relation trans_part --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_ate_cam_traj > ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/ate_${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.log


evo_traj tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.txt --ref=${DATASET}/$DIR/$REFERENCE -p --plot_mode=xyz --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/3d_cam_traj
evo_traj tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_cam_traj_coordinate_aligned.txt --ref=${DATASET}/$DIR/$REFERENCE -p --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_cam_traj

# # keyframe
evo_rpe tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.txt ${DATASET}/$DIR/$REFERENCE --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_rpe_kf_traj > ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/rpe_${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.log
evo_ape tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.txt ${DATASET}/$DIR/$REFERENCE --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_ape_kf_traj > ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/ape_${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.log
evo_ape tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.txt ${DATASET}/$DIR/$REFERENCE --align --pose_relation trans_part --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_ate_kf_traj > ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/ate_${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.log


evo_traj tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.txt --ref=${DATASET}/$DIR/$REFERENCE -p --plot_mode=xyz --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/3d_kf_traj
evo_traj tum ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/${ESITMATED_FOLDER}_kf_traj_coordinate_aligned.txt --ref=${DATASET}/$DIR/$REFERENCE -p --plot_mode=xy --save_plot ${DATASET}/$DIR/${ESITMATED_FOLDER}/${TEST_DIR}/2d_kf_traj
