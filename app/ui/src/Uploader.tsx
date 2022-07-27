import { useState } from "react";
import "react-dropzone-uploader/dist/styles.css";
import Dropzone from "react-dropzone-uploader";
import axios from "axios";

const Uploader = () => {
  const handleChangeStatus = ({ meta, remove }: any, status: any) => {
    setTriggerChange(Math.random());
  };

  const [_, setTriggerChange] = useState<number>(Math.random());
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false);
  const [allowViewFiles, setAllowViewFiles] = useState<boolean>(false);
  const [s3Links, sets3Links] = useState<string[]>([]);
  const [error, setError] = useState<string>("");

  const [imageId, setImageId] = useState<string>("");
  const handleSubmit = async (files: any) => {
    setIsSubmitting(true);
    const f = files[0];
    try {
      const response = await axios.get("http://localhost:3000/dev/presign-url");

      await axios.put(
        response.data.url,
        {
          body: f["file"],
        },
        {
          headers: { "Content-Type": f.type },
        }
      );

      alert("File uploaded successfully to S3");
      setAllowViewFiles(true);
      setImageId(response.data.id);
    } catch (error) {
      console.error(error);
      alert("File failed to upload, please check the logs.");
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleGetLinks = async (e: any) => {
    setError("");
    try {
      const response = await axios.get(
        `http://localhost:3000/dev/image/${imageId}`
      );

      sets3Links(response.data.links);
    } catch (error) {
      setError(
        "The links are not ready yet, please wait a moment before trying again."
      );
    }
  };

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        alignItems: "center",
      }}
    >
      <Dropzone
        onChangeStatus={handleChangeStatus}
        onSubmit={handleSubmit}
        maxFiles={1}
        multiple={false}
        canCancel={false}
        submitButtonDisabled={isSubmitting}
        accept="image/jpeg, image/png"
        inputContent="Upload an image"
        styles={{
          dropzone: { height: 200, width: 400 },
          dropzoneActive: { borderColor: "green" },
        }}
      />
      {allowViewFiles && (
        <>
          <button
            className="dzu-submitButton"
            style={{
              width: 400,
            }}
            onClick={(e) => handleGetLinks(e)}
          >
            Get links
          </button>

          {error && <p>{error}</p>}

          {s3Links.length > 0 && (
            <ul>
              {s3Links.map((link) => (
                <li>
                  <a href={link} target="_blank" rel="noreferrer">
                    {link}
                  </a>
                </li>
              ))}
            </ul>
          )}
        </>
      )}
    </div>
  );
};

export default Uploader;
