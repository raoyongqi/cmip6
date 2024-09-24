# 加载必要的包
if (!requireNamespace("raster", quietly = TRUE)) {
  install.packages("raster")
}
if (!requireNamespace("openxlsx", quietly = TRUE)) {
  install.packages("openxlsx")
}

library(raster)
library(openxlsx)

# 设置工作目录
setwd("C:/Users/r/Desktop/cmip6/CMIP6/ACCESS-CM2/ssp585/2021-2040")

# 读取 Excel 文件中的经纬度数据
data <- read.xlsx("1_Alldata.xlsx", sheet = "Lacation")
names(data) <- tolower(names(data))

# 检查是否包含 'lon' 和 'lat' 列
if (!all(c('lon', 'lat') %in% names(data))) {
  stop("Excel 文件需要包含 'lon' 和 'lat' 列")
}

# 获取当前目录下所有 TIFF 文件
tif_files <- list.files(pattern = "\\.tif$", full.names = TRUE)

# 初始化结果数据框
result <- data

# 迭代每个 TIFF 文件，提取数据
for (file_path in tif_files) {
  cat("Processing file:", file_path, "\n")
  
  # 加载栅格数据
  clim_data <- brick(file_path)  # 使用 brick 读取多波段文件
  
  # 获取变量名称
  band_names <- names(clim_data)
  
  # 初始化进度条
  pb <- txtProgressBar(min = 0, max = nrow(data), style = 3)
  
  # 迭代每个变量，提取数据
  for (band in band_names) {
    cat("  Processing variable:", band, "\n")
    
    all_clim_values <- numeric(nrow(data))
    
    for (i in 1:nrow(data)) {
      lon <- data$lon[i]
      lat <- data$lat[i]
      
      # 提取样点的栅格值
      clim_values <- extract(clim_data[[band]], cbind(lon, lat))
      all_clim_values[i] <- clim_values  # 将值存储在向量中
      
      # 更新进度条
      setTxtProgressBar(pb, i)
    }
    
    # 关闭进度条
    close(pb)
    
    # 将提取到的数据添加到结果数据框中
    result <- cbind(result, all_clim_values)
    names(result)[ncol(result)] <- band  # 设置新列的名称为变量名
  }
}

# 保存结果到新的 Excel 文件
output_file_path <- "climate_data.xlsx"
write.xlsx(result, output_file_path, rowNames = FALSE)

# 完成
cat("气候数据已成功保存到", output_file_path, "\n")
