library(raster)
setwd("C:/Users/r/Desktop/cmip6/CMIP6/ACCESS-CM2/ssp585")
# 设置输入和输出目录
input_directory <- "2021-2040"
output_directory <- "2021-2040s"

# 创建输出目录（如果不存在）
if (!dir.exists(output_directory)) {
  dir.create(output_directory)
}

# 获取输入目录中所有多波段 TIFF 文件的列表
tif_files <- list.files(input_directory, pattern = "\\.tif$", full.names = TRUE)

# 遍历每个多波段 TIFF 文件
for (tif_file in tif_files) {
  # 读取多波段 TIFF 文件
  multiband_raster <- stack(tif_file)
  
  # 获取波段数量
  num_bands <- nlayers(multiband_raster)
  
  # 获取波段名称（假设名称以变量的形式存储）
  band_names <- names(multiband_raster)
  
  # 遍历每个波段
  for (band in 1:num_bands) {
    # 提取单波段数据
    single_band <- raster(multiband_raster, band)
    
    # 创建输出文件名，使用波段名称作为变量名
    output_filename <- paste0(band_names[band], ".tif")
    output_path <- file.path(output_directory, output_filename)
    
    # 写入单波段 TIFF 文件
    writeRaster(single_band, filename = output_path, format = "GTiff", overwrite = TRUE)
  }
}

cat("转换完成！\n")
