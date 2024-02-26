"""
This module provides functions for interacting with databases and loading data from CSV files.

Functions:

   - create_db_engine: Creates a database engine based on a given connection string.
   - query_data: Queries a database using SQL and returns the results as a pandas DataFrame.
   - read_from_web_CSV: Reads a CSV file from a web URL and returns a pandas DataFrame.
"""

import pandas as pd # importing the Pandas package with an alias, pd
from sqlalchemy import create_engine, text # Importing the SQL interface. If this fails, run !pip install sqlalchemy in another cell.
import logging

# Name our logger so we know that logs from this module come from the data_ingestion module
logger = logging.getLogger('data_ingestion')

# Set a basic logging message up that prints out a timestamp, the name of our logger, and the message
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')


### START FUNCTION

def create_db_engine(db_path):
    """
    Creates a database engine using SQLAlchemy.

    Args:
        db_path (str): The connection string to the database.

    Returns:
        engine: A SQLAlchemy engine object.

    Raises:
        ImportError: If SQLAlchemy is not installed.
        Exception: If the database engine cannot be created.
    """
    try:
        engine = create_engine(db_path)
        # Test connection
        with engine.connect() as conn:
            pass
        # test if the database engine was created successfully
        logger.info("Database engine created successfully.")
        return engine # Return the engine object if it all works well
    except ImportError: #If we get an ImportError, inform the user SQLAlchemy is not installed
        logger.error("SQLAlchemy is required to use this function. Please install it first.")
        raise e
    except Exception as e:# If we fail to create an engine inform the user
        logger.error(f"Failed to create database engine. Error: {e}")
        raise e
    
def query_data(engine, sql_query):
    """
    Queries a database using SQL and returns the results as a pandas DataFrame.

    Args:
        engine (sqlalchemy.engine.Engine): A SQLAlchemy engine object.
        sql_query (str): The SQL query to execute.

    Returns:
        pd.DataFrame: The results of the query as a DataFrame.

    Raises:
        ValueError: If the query returns an empty DataFrame.
        Exception: If an error occurs while querying the database.
    """
    try:
        with engine.connect() as connection:
            df = pd.read_sql_query(text(sql_query), connection)
        if df.empty:
            # Log a message or handle the empty DataFrame scenario as needed
            msg = "The query returned an empty DataFrame."
            logger.error(msg)
            raise ValueError(msg)
        logger.info("Query executed successfully.")
        return df
    except ValueError as e: 
        logger.error(f"SQL query failed. Error: {e}")
        raise e
    except Exception as e:
        logger.error(f"An error occurred while querying the database. Error: {e}")
        raise e
    
def read_from_web_CSV(URL):
    """
    Reads a CSV file from a web URL and returns a pandas DataFrame.

    Args:
        URL (str): The URL of the CSV file to read.

    Returns:
        pd.DataFrame: The contents of the CSV file as a DataFrame.

    Raises:
        pd.errors.EmptyDataError: If the URL does not point to a valid CSV file.
        Exception: If an error occurs while reading the CSV file.
    """
    try:
        df = pd.read_csv(URL)
        logger.info("CSV file read successfully from the web.")
        return df
    except pd.errors.EmptyDataError as e:
        logger.error("The URL does not point to a valid CSV file. Please check the URL and try again.")
        raise e
    except Exception as e:
        logger.error(f"Failed to read CSV from the web. Error: {e}")
        raise e
    
### END FUNCTION


# db_path = 'sqlite:///Maji_Ndogo_farm_survey_small.db'

# sql_query = """
# SELECT *
# FROM geographic_features
# LEFT JOIN weather_features USING (Field_ID)
# LEFT JOIN soil_and_crop_features USING (Field_ID)
# LEFT JOIN farm_management_features USING (Field_ID)
# """

# weather_data_URL = "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_station_data.csv"
# weather_mapping_data_URL = "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_data_field_mapping.csv"

config_params = {
    "sql_query": """
        SELECT *
            FROM geographic_features
            LEFT JOIN weather_features USING (Field_ID)
            LEFT JOIN soil_and_crop_features USING (Field_ID)
            LEFT JOIN farm_management_features USING (Field_ID)
            """, # Insert your SQL query
    "db_path": 'sqlite:///Maji_Ndogo_farm_survey_small.db', # Insert the db_path of the database
    "columns_to_rename": {'Annual_yield': 'Crop_type', 'Crop_type': 'Annual_yield'},# Insert the disctionary of columns we want to swop the names of, 
    "values_to_rename": {'cassaval': 'cassava', 'wheatn': 'wheat', 'teaa': 'tea'}, # Insert the croptype renaming dictionary
    "weather_csv_path": "https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_station_data.csv", # Insert the weather data CSV here
    "weather_mapping_csv":"https://raw.githubusercontent.com/Explore-AI/Public-Data/master/Maji_Ndogo/Weather_data_field_mapping.csv", # Insert the weather data mapping CSV here
}

field_df = query_data(create_db_engine(db_path), sql_query)   
weather_df = read_from_web_CSV(weather_data_URL)
weather_mapping_df = read_from_web_CSV(weather_mapping_data_URL)

field_test = field_df.shape
weather_test = weather_df.shape
weather_mapping_test = weather_mapping_df.shape
print(f"field_df: {field_test}, weather_df: {weather_test}, weather_mapping_df: {weather_mapping_test}")