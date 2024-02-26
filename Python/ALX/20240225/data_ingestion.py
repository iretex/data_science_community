from module import *

# Name our logger so we know that logs from this module come from the data_ingestion module
logger = logging.getLogger('data_ingestion')
# Set a basic logging message up that prints out a timestamp, the name of our logger, and the message
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
db_path = 'sqlite:///Maji_Ndogo_farm_survey_small.db'

sql_query = """
SELECT *
FROM geographic_features
LEFT JOIN weather_features USING (Field_ID)
LEFT JOIN soil_and_crop_features USING (Field_ID)
LEFT JOIN farm_management_features USING (Field_ID)
"""

weather_data_URL = "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_station_data.csv"
weather_mapping_data_URL = "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_data_field_mapping.csv"


field_df = query_data(create_db_engine(db_path), sql_query)   
weather_df = read_from_web_CSV(weather_data_URL)
weather_mapping_df = read_from_web_CSV(weather_mapping_data_URL)

field_test = field_df.shape
weather_test = weather_df.shape
weather_mapping_test = weather_mapping_df.shape
print(f"field_df: {field_test}, weather_df: {weather_test}, weather_mapping_df: {weather_mapping_test}")