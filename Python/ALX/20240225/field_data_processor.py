import pandas as pd
from data_ingestion import create_db_engine, query_data, read_from_web_CSV
import logging

### START FUNCTION

class FieldDataProcessor:

    def __init__(self, config_params, logging_level="INFO"):  # Make sure to add this line, passing in config_params to the class 
        self.db_path = config_params['db_path']
        self.sql_query = config_params['sql_query']
        self.columns_to_rename = config_params['columns_to_rename']
        self.values_to_rename = config_params['values_to_rename']
        self.weather_map_data = config_params['weather_mapping_csv']

        # Add the rest of your class code here

        self.initialize_logging(logging_level)

        # We create empty objects to store the DataFrame and engine in
        self.df = None
        self.engine = None

    # This method enables logging in the class.
    def initialize_logging(self, logging_level):
        """
        Sets up logging for this instance of FieldDataProcessor.
        """
        logger_name = __name__ + ".FieldDataProcessor"
        self.logger = logging.getLogger(logger_name)
        # Prevents log messages from being propagated to the root logger
        self.logger.propagate = False

        # Set logging level
        if logging_level.upper() == "DEBUG":
            log_level = logging.DEBUG
        elif logging_level.upper() == "INFO":
            log_level = logging.INFO
        elif logging_level.upper() == "NONE":  # Option to disable logging
            self.logger.disabled = True
            return
        else:
            log_level = logging.INFO  # Default to INFO

        self.logger.setLevel(log_level)

        # Only add handler if not already added to avoid duplicate messages
        if not self.logger.handlers:
            ch = logging.StreamHandler()  # Create console handler
            formatter = logging.Formatter(
                '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
            ch.setFormatter(formatter)
            self.logger.addHandler(ch)

        # Use self.logger.info(), self.logger.debug(), etc.

    # let's focus only on this part from now on

    # def ingest_sql_data(self):
    #     self.engine = create_db_engine(self.db_path)
    #     self.df = query_data(self.engine, self.sql_query)
    #     self.logger.info("Sucessfully loaded data.")
    #     return self.df
    def ingest_sql_data(self):
        self.engine = create_db_engine(self.db_path)
        self.df = query_data(self.engine, self.sql_query)
        self.logger.info("Successfully loaded data.")
        return self.df  # Return the DataFrame

# Copy in your class including the ingest_sql_data method here

    def rename_columns(self):
        # Extract the columns to rename from the configuration
        column1, column2 = list(self.columns_to_rename.keys())[
            0], list(self.columns_to_rename.values())[0]

        # Temporarily rename one of the columns to avoid a naming conflict
        temp_name = "__temp_name_for_swap__"
        while temp_name in self.df.columns:
            temp_name += "_"

        # Perform the swap
        self.df = self.df.rename(
            columns={column1: temp_name, column2: column1})
        self.df = self.df.rename(columns={temp_name: column2})
        
        self.logger.info(f"Swapped columns: {column1} with {column2}")
        return self.df  # Return the DataFrame


# Copy in your class including the ingest_sql_data and  method here


    def apply_corrections(self, column_name='Crop_type', abs_column='Elevation'):
        self.df[abs_column] = self.df[abs_column].abs()
        self.df[column_name] = self.df[column_name].apply(
            lambda crop: self.values_to_rename.get(crop, crop))
        return self.df  # Return the DataFrame

# Copy in your class including the ingest_sql_data and method here

    def weather_station_mapping(self):
        return read_from_web_CSV(self.weather_map_data)

    def process(self):
        # This process calls the correct methods and applies the changes, step by step. This is the method we will call, and it will call the other methods in order.
        weather_map_df = self.weather_station_mapping()
        self.df = self.ingest_sql_data()
        self.df = self.apply_corrections()
        self.df = self.rename_columns()
        self.df = self.df.merge(weather_map_df, on='Field_ID', how='left')
        self.df = self.df.drop(columns="Unnamed: 0")
        
### END FUNCTION